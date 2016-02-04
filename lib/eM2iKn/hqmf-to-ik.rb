require_relative '../health-data-standards/lib/hqmf-parser'
require_relative '../knime/util/knime-workflow'
require_relative '../knime/util/knime-node'
require_relative '../phema-utils/mappings'
require_relative '../knime/util/mappings-knime'

# test procedures in irb
# require_relative 'lib/eM2iKn/hqmf-to-ik'
# h_p = PhEMA::Em2iKn::HQMF_Project.new(open("example/cms30-hqmf2.xml").read)
# wf = h_p.get_knime_workflow

module PhEMA
  module Em2iKn
    class HQMF_Project
      # @@wf_col_width = 200
      # @@wf_row_height = 150

      def initialize(hqmf_content, project_name = "", hqmf_version = "2.0")
        #hqmf_content is open('file_path.xml').read

        @sdc_col = 4
        @dc_col_start = 6 # data criteria starting column

        @count = 0

        if hqmf_version.eql? "1.0"
          @parser = HQMF::Parser::V1Parser.new()
        else
          @parser = HQMF::Parser::V2Parser.new()
        end

        @hqmf_model = @parser.parse(hqmf_content)
        # source_data_criteria
        # value set: hqmf.all_data_criteria[1].all_code_set_oids
        # All value sets: hqmf.all_code_set_oids
        @knime = PhEMA::KNIME::KnimeWorkflow.new(project_name.empty? ? @hqmf_model.title : project_name)  #knime workflow project

        @source_dcs = {}  # HQMF::DataCriteria object.id => HQMF::DataCriteria object (source)
        @dc_nodes_id = {}      # HQMF::DataCriteria object.id => HQMF::DataCriteria object
        @sdc_nodes_id = {} # (source) HQMF::DataCriteria object.id => knime node id
        @sdc_derived_nodes_id = {} # deal with the satisfies_all; can be fixed with asynchronizing in the future
        @sdcs_row = 1 # will increment when add_source_data_criteria() is called

        @unsolved_dcs_ref = {}  # relay node ids => HQMF::DataCriteria object.id

        # Deal with ource_data_criteria
        @hqmf_model.source_data_criteria.each do |dc_o|
          @source_dcs[dc_o.id] = dc_o
          # Map to config file
          add_source_data_criteria(dc_o)
        end

        @sdc_derived_nodes_id.each do |dc_id, node_id|
          # TODO deal with sdc_derived_nodes_id!
          group_node_coord = @knime.get_node_coordinator(node_id)
          # puts "#{dc_id}, #{node_id}, #{group_node_coord}"
          # puts group_node_coord

          dc_o = @source_dcs[dc_id]

          # add_concatted_relays(in_nodes_id, source_outports, source_texts, x_start, y)
          # return {:node_id => top_node_id, :x_max => x_max}
          children_nodes_id = []
          children_outports = []
          children_texts = []
          dc_o.children_criteria.each do |child_dc_id|
            child_node_id = @sdc_nodes_id[child_dc_id]
            children_nodes_id << child_node_id

            child_knode = @knime.get_knime_node_object(child_node_id)
            children_outports << child_knode.find_outport("encounter_set") || child_knode.get_all_outports.first

            children_texts << child_dc_id

          end

          concat_re = add_concatted_relays(children_nodes_id, children_outports, children_texts, group_node_coord[:x], group_node_coord[:y])
          @knime.set_node_coordinator(node_id, concat_re[:x_max] + 1, group_node_coord[:y])

          if @dc_col_start < concat_re[:x_max] + 3
            @dc_col_start = concat_re[:x_max] + 3
          end

          # add_knime_connection(sourceID = "", destID = "", sourcePort = "", destPort = "")
          @knime.add_knime_connection(concat_re[:node_id], node_id, "1", "1")

        end

        puts "End of source data criteria"


        # Deal with data_criteria
        max_dcs_col = @dc_col_start
        dcs_row = 1
        # puts @hqmf_model.all_data_criteria.size
        @hqmf_model.all_data_criteria.each do |dc_o|
          #puts "hello\n"
          furthest_node_id = ""
          current_col = @dc_col_start
          # deal with principal source data criteria
          source_node_id = ""
          if @source_dcs.has_key?(dc_o.id)
            source_node_id = @sdc_nodes_id[dc_o.id]
          else
            # if the deta element was not in source data criteria yet
            # create a new source data criteria for it
            source_node_id = add_source_data_criteria(dc_o)
          end

          # add a relay node
          principal_node_id = add_relay_connection_backward(source_node_id, @knime.get_knime_node_object(source_node_id).find_outport("encounter_set"), dc_o.id)
          # set coordiantor of relay node
          @knime.set_node_coordinator(principal_node_id, current_col, dcs_row)
          current_col += 1
          furthest_node_id = principal_node_id

          # deal with Temporal
          # assume each data criteria has only one temporal reference?
          dc_o.temporal_references.each do |temp_ref|
            temp_type = temp_ref.type  # need to map to config file
            referred_id = temp_ref.reference.id

            if referred_id.to_s.include? "MeasurePeriod"   # i2b2 does not support MeasurePeriod
              # if refer to MeasurePeriod, we only put a dummy relay node there without connections
              ref_knode = PhEMA::KNIME::KnimeNode.new("lib/qdm-knime/qdm-knime-guides/knime_nodes/relay.json")
              ref_knode.update_configs({"node_text" => referred_id.to_s})
              @knime.add_knime_node(ref_knode, current_col, dcs_row)
              current_col += 1
            elsif PhEMA::KNIME::QDM_KNIME_TEMPORAL_MAPPING.has_key?(temp_type)
              #puts PhEMA::KNIME::QDM_KNIME_TEMPORAL_MAPPING[temp_type].to_s
              # create and add temporal nodes
              temporal_knode = PhEMA::KNIME::KnimeNode.new(PhEMA::KNIME::QDM_KNIME_TEMPORAL_MAPPING[temp_type])
              temporal_knode.update_configs(PhEMA::KNIME::I2B2_QDM_KNIME_TEMPORAL_CONFIGS[temp_type])
              temporal_knode.update_configs("node_text" => "#{dc_o.id}\n#{temp_type}\n#{referred_id}")
              temporal_node_id = @knime.add_knime_node(temporal_knode)
              @knime.add_knime_connection(furthest_node_id, temporal_node_id, "0", "1")
              ref_relay_node_id = add_relay_connection_forward(temporal_node_id, "2", referred_id.to_s)

              # align the new temporal nodes
              @knime.set_node_coordinator(ref_relay_node_id, current_col, dcs_row)
              current_col += 1
              @knime.set_node_coordinator(temporal_node_id, current_col, dcs_row)
              current_col += 1
              @unsolved_dcs_ref[ref_relay_node_id] = referred_id
              furthest_node_id = temporal_node_id
            end

          end

          # TODO: deal with lab or other attributes
          # backward add criteria to referred source node
          # health-data-standards lib does not support!
          # dc_o.value ???

          # TODO: Group by?

          dcs_row += 1
          if current_col > max_dcs_col
            max_dcs_col = current_col
          end
          @dc_nodes_id[dc_o.id] = furthest_node_id

        end

        # TODO: connect @unsolved_dcs_ref: relay node ids => HQMF::DataCriteria object.id
        @unsolved_dcs_ref.each do |relay_node_id, source_id|
          @knime.add_knime_connection(@dc_nodes_id[source_id], relay_node_id, @knime.get_knime_node_object(@dc_nodes_id[source_id]).find_outport("encounter_set"), "0")
        end

        # puts @dc_nodes_id.to_json
=begin
        # deal with population_criteria
        pcs_start_col = max_dcs_col + 2
        pcs_row = 1
        all_pops = @hqmf_model.populations
        all_pops.each do |pop_group|
          pop_group_id = pop_group["id"]
          pop_group_title = pop_group["title"]
          ipp_node_id = nil
          pop_group.each do |pop_key, pop_pointed|
            # puts pop_key.to_s
            pop_criteria = @hqmf_model.population_criteria(pop_pointed)
            unless (pop_criteria.nil?) # skip the "title" and "id"
              # Preconditions recursive
              #puts "#{pop_key}\n"
              if ipp_node_id.nil?
                re_hash = explore_precondition(pop_criteria, pcs_start_col, pcs_row)
              else
                re_hash = explore_precondition(pop_criteria, pcs_start_col, pcs_row, ipp_node_id)
              end
              if pop_key.eql? "IPP"
                ipp_node_id = re_hash[:top_node_id]
              end
              # puts ipp_node_id
              relay_node_id = add_relay_connection_backward(re_hash[:top_node_id], "0", pop_key)
              @knime.set_node_coordinator(relay_node_id, re_hash[:x] + 1, pcs_row)
              pcs_row = re_hash[:y] + 2

            end
          end
        end
=end
        return ""
      end

      def get_knime_workflow
        return @knime
      end

      def add_source_data_criteria(data_criteria_object)
        element_map = PhEMA::HealthDataStandards::QDM_HQMF_MAPPING.detect do |x|

          x[:definition].to_s.eql?(data_criteria_object.definition.to_s) && x[:status].to_s.eql?(data_criteria_object.status.to_s) || (x[:type].eql?(:derived) && x[:derivation_operator].eql?(data_criteria_object.derivation_operator))
          # puts "Map: #{x[:definition]} #{x[:status]}\n"
        end
        #puts "#{data_criteria_object.definition.to_s} #{data_criteria_object.status.to_s} id: #{@count}\n"
        #@count += 1

        der_uri = element_map[:id]
        config_map = PhEMA::KNIME::DER_KNIME_MAPPING.detect { |x|  x[:id].eql?(der_uri)}
        config_path = config_map[:knime_cofig]
        knode = PhEMA::KNIME::KnimeNode.new(config_path)
        knode.update_configs({
          "node_text" => "#{data_criteria_object.id}\n#{data_criteria_object.description}\n#{data_criteria_object.code_list_id}",
          "oid_node_text" => "#{data_criteria_object.title}\n#{data_criteria_object.code_list_id}",
          "oid_filter" => data_criteria_object.code_list_id.to_s
        })
        node_id = @knime.add_knime_node(knode, @sdc_col, @sdcs_row)

        # TODO deal with "INTERSECT"
        if data_criteria_object.type.eql? (:derived)
          @sdc_derived_nodes_id[data_criteria_object.id()] = node_id
        end

        # register source data criteria node_id
        @sdc_nodes_id[data_criteria_object.id] = node_id

        @sdcs_row += 1

        return node_id

      end

      def explore_precondition (precondition, x_start, y_start, *ipp_node_id)

        # It should be a better idea to use instance variables to store outputs to the @knime
        x_max = x_start
        y_max = y_start

        # deal with the reference
        refered_node_id = nil
        if precondition.methods.include?(:reference) && ! precondition.reference.nil?
          ref = precondition.reference.id
          #puts "#{ref.to_json}\n"
          refered_node_id = @dc_nodes_id[ref]
          #puts "#{refered_node_id}\n"
        end
        nodes_id = ipp_node_id # either ipp_node_id or empty
        top_node_id = nil
        # puts top_node_id
        unless refered_node_id.nil?
          refered_node_id = add_relay_connection_backward(refered_node_id, "0", ref.to_s)
          y_max += 1
          @knime.set_node_coordinator(refered_node_id, x_max, y_max)

          nodes_id << refered_node_id
          top_node_id = refered_node_id
        end

        # visit each precondition

        re_x_max = x_max  # TODO: is it good?
        re_y_max = y_max

        # TODO: get precondition types

        precond_type = precondition.conjunction_code
        precond_config_lib = PhEMA::KNIME::QDM_KNIME_LOGICAL_CONJUNCTION_MAPPING[precond_type]
        #puts precond_type + "\n" + precond_config_lib.to_json + "\n"
        precondition.preconditions.each do | precond_next |
          re_hash = explore_precondition(precond_next, x_max, y_max)
          nodes_id << re_hash[:top_node_id]
          # TODO undate x_max, y_max with re_coord; be aware of recursive use
        end

        # TODO: need to fix here
        x_max = re_x_max
        y_max = re_y_max

        # deal with source_outports
        source_outports = []
        source_texts = []
        # puts nodes_id.join(", ")
        nodes_id.each do |nid|
          kn = @knime.get_knime_node_object(nid)
          #puts kn.find_outport("patient_set")
          source_outports << (kn.find_outport("patient_set").nil?() ? kn.get_all_outports.first() : kn.find_outport("patient_set"))
          source_texts << ""  # TODO need to fix this
        end

        #puts source_outports
        # Deal with concat_opt_in nodes
        concat_line_config = add_concatted_relays(nodes_id, source_outports, source_texts, x_max, y_max)
        # return {:node_id => top_node_id, :x_max => x_max}

        # TODO: add precondition node
        top_node_id = concat_line_config[:node_id]
        x_max = concat_line_config[:x_max]

        if ! precond_config_lib.nil?
          precond_knode = PhEMA::KNIME::KnimeNode.new(precond_config_lib["config_path"])
          precond_node_id = @knime.add_knime_node(precond_knode, x_max, y_max)
          precond_knode.update_configs(precond_config_lib["configs"])
          @knime.add_knime_connection(top_node_id, precond_node_id, @knime.get_knime_node_object(top_node_id).find_outport("patient_set"), "1")
          # TODO update top_node_id
          top_node_id = precond_node_id
          # puts "hello\n"
        end


        x_max += 1  # TODO deal with x here?

        #puts "#{top_node_id}"

        return {:x => x_max, :y => y_max, :top_node_id => top_node_id}

      end

      def add_relay_connection_backward(source_node_id, source_port, text = "relay")
        knode = PhEMA::KNIME::KnimeNode.new("lib/qdm-knime/qdm-knime-guides/knime_nodes/relay.json")
        knode.update_configs({"node_text" => text})
        node_id = @knime.add_knime_node(knode)
        @knime.add_knime_connection(source_node_id, node_id, source_port, "0")
        return node_id
      end

      def add_relay_connection_forward(dest_node_id, dest_port, text = "relay")
        knode = PhEMA::KNIME::KnimeNode.new("lib/qdm-knime/qdm-knime-guides/knime_nodes/relay.json")
        knode.update_configs({"node_text" => text})
        node_id = @knime.add_knime_node(knode)
        @knime.add_knime_connection(node_id, dest_node_id, "0", dest_port)
        return node_id
      end

      def add_concatted_relays(in_nodes_id, source_outports, source_texts, x_start, y)

        # puts in_nodes_id.join(", ")
        # puts source_outports.join(", ")

        x_max = x_start
        # i = 0
        top_node_id = nil

        in_nodes_id.each_with_index do |source_node_id, i|
          # Round 1: create 1st concat_opt_in as top_node_id, connect 1st source to the concat
          # Round 2 ~ 4: concat source to top_node_id
          # Round 5: create 2nd concat_opt_in as top_node_id, connnect 1st concat to the 2nd concat
          # then add source to 2nd concat

          # puts "#{source_node_id} #{i}"

          relay_node_id = add_relay_connection_backward(source_node_id, source_outports[i], source_texts[i])
          @knime.set_node_coordinator(relay_node_id, x_max, y)
          # puts "#{relay_node_id} #{x_max} #{y}"
          x_max += 1
          # unconcatted_nodes_id << relay_node_id

          # x_max += 1

          if (i % 3 == 0)
            knode = PhEMA::KNIME::KnimeNode.new("lib/qdm-knime/qdm-knime-guides/knime_nodes/concat_opt_in.json")
            new_node_id = @knime.add_knime_node(knode, x_max + 4, y)  # TODO check coordinator
            # TODO may be duplicate in the first one
            unless top_node_id.nil?    # condition to deal with the first concat_opt_in
              @knime.add_knime_connection(top_node_id, new_node_id, @knime.get_knime_node_object(top_node_id).get_all_outports.first, "1")
              @knime.set_node_coordinator(top_node_id, x_max, y)
            end
            x_max += 1
            top_node_id = new_node_id
          end
          knode = @knime.get_knime_node_object(source_node_id)
          #puts "#{node_id}\n"
          #source_port = knode.get_all_outports.first

          dest_port = (i % 3) + 1
          if i > 0 && dest_port == 1
            dest_port = 4
          end

          @knime.add_knime_connection(relay_node_id, top_node_id, "0", dest_port.to_s)
          # i += 1
        end
        unless top_node_id.nil?
          @knime.set_node_coordinator(top_node_id, x_max, y)
        end
        return {:node_id => top_node_id, :x_max => x_max + 1}
      end


    end
  end
end

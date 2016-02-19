require 'nokogiri'
require 'fileutils'
#require 'zip/zip'
#require 'zip/zipfilesystem'
require 'find'
require 'tmpdir'
require 'erb'
require 'ostruct'
require_relative 'knime-node'

module PhEMA
  module KNIME
    class KnimeWorkflow
      @@wf_col_width = 150
      @@wf_row_height = 150

      @@new_node_template = open('lib/knime/xml_templates/node_dom_template.erb').read
      @@new_conn_template = open('lib/knime/xml_templates/connection_dom_template.erb').read

      def initialize(project_name)
        @p_name = project_name
        @workflow_xml = Nokogiri::XML File.open 'lib/knime/xml_templates/root_workflow.knime'
        @knode_sn = 0;
        @kconn_sn = 0;
        @nodes = {};    # {"node_id" => PhEMA::KNIME::KnimeNode}
        @account_node_id = nil
        # data structure design: use xpath to get nodes and connections
        #puts @project_file.to_xml
      end

      def add_i2b2_account()
        account_knode = PhEMA::KNIME::KnimeNode.new("lib/qdm-knime/qdm-knime-guides/knime_nodes/i2b2_account.json")
        @account_node_id = add_knime_node(account_knode, 1, 1)
      end

      def add_knime_node(knode, x_coord = rand(10), y_coord = rand(10))
        node_id = ""
        @knode_sn += 1

        if knode.class <= PhEMA::KNIME::KnimeNode
          node_id = "#{@knode_sn}"
          nodes_dom = @workflow_xml.xpath("/xmlns:config/xmlns:config[@key='nodes']").first

          # add a block of xml to the root workflow.knime for the new node
          #new_node_template = ""
          #open('lib/knime/xml_templates/node_dom_template.erb') {|f| new_node_template = f.to_a.join}
          # puts "x: #{x} y: #{y}"


          x = x_coord * @@wf_col_width
          y = y_coord * @@wf_row_height

          new_node_xml = Nokogiri::XML ERB.new(@@new_node_template, 0, "%<>").result(
            OpenStruct.new(
              :node_id => node_id,
              :node_type => knode.get_knime_node_type,
              :node_is_meta => knode.get_knime_node_is_meta,
              :file_name => knode.get_knime_node_is_meta == "true" ? "workflow.knime" : "settings.xml",
              :x => x.to_s, :y => y.to_s
            ).instance_eval {binding}
          )
          # puts new_node_xml.to_xml
          nodes_dom.add_child(new_node_xml.root)

          @nodes[node_id] = knode
        end

        if knode.i2b2?() && ! @account_node_id.nil?
          add_knime_connection(@account_node_id, node_id, "1", "0")
        end

        return node_id
      end

      def add_knime_connection(sourceID = "", destID = "", sourcePort = "", destPort = "")
        if sourceID.blank? || destID.blank? || sourcePort.blank? || destPort.blank?
          raise "sourceID: #{sourceID}; destID: #{destID}; sourcePort: #{sourcePort}; destPort: #{destPort}"
        end
        @kconn_sn = @kconn_sn + 1
        conn_id = "#{@kconn_sn}";
        conns_dom = @workflow_xml.xpath("/xmlns:config/xmlns:config[@key='connections']").first

        #new_conn_template = ""
        #open('lib/knime/xml_templates/connection_dom_template.erb') {|f| new_conn_template = f.to_a.join}
        new_conn_xml = Nokogiri::XML ERB.new(@@new_conn_template, 0, "%<>").result(
          OpenStruct.new(
            :connection_id => conn_id,
            :sourceID => sourceID,
            :sourcePort => sourcePort,
            :destPort => destPort
          ).instance_eval {binding}
        )
        #if destID.blank?
        #  raise "destID is blank"
        #end
        conns_dom.add_child(new_conn_xml.root)
        return conn_id
      end

      def delete_node (node_id)
        # please test before use
        node_dom = @workflow_xml.xpath(
          "/xmlns:config/xmlns:config[@key='nodes']/xmlns:config[xmlns:entry[@key='id']/@value='#{node_id}']"
        ).first
        node_dom.remove    # maybe need to handle nil
        # TODO: remove connnections
        @nodes.delete(node_id)
      end

      def delete_connection (conn_id)
        # please test before use
        conn_dom = @workflow_xml.xpath(
          "/xmlns:config/xmlns:config[@key='connections']/xmlns:config[@key='connection_#{conn_id}']"
        ).first
        conn_dom.remove
      end

      def set_node_coordinator (node_id, x, y)
        node_dom = @workflow_xml.xpath(
          "/xmlns:config/xmlns:config[@key='nodes']/xmlns:config[xmlns:entry[@key='id']/@value='#{node_id}']"
        ).first
        x_attr_dom = node_dom.xpath(
          "xmlns:config[@key='ui_settings']/xmlns:config[@key='extrainfo.node.bounds']/xmlns:entry[@key='0']/@value"
        ).first
        y_attr_dom = node_dom.xpath(
          "xmlns:config[@key='ui_settings']/xmlns:config[@key='extrainfo.node.bounds']/xmlns:entry[@key='1']/@value"
        ).first
        x_attr_dom.value = (x * @@wf_col_width).to_s
        y_attr_dom.value = (y * @@wf_row_height).to_s
        # puts node_dom.to_xml
        # puts "x #{x} #{x_attr_dom.value}"
        # puts "y #{y} #{y_attr_dom.value}"
      end

      def get_node_coordinator (node_id)
        node_dom = @workflow_xml.xpath(
          "/xmlns:config/xmlns:config[@key='nodes']/xmlns:config[xmlns:entry[@key='id']/@value='#{node_id}']"
        ).first
        # puts "get \n #{node_dom.to_xml}"
        x_attr_dom = node_dom.xpath(
          "xmlns:config[@key='ui_settings']/xmlns:config[@key='extrainfo.node.bounds']/xmlns:entry[@key='0']/@value"
        ).first
        y_attr_dom = node_dom.xpath(
          "xmlns:config[@key='ui_settings']/xmlns:config[@key='extrainfo.node.bounds']/xmlns:entry[@key='1']/@value"
        ).first
        x_coord = x_attr_dom.value.to_i
        y_coord = y_attr_dom.value.to_i
        # puts "#{x_coord} #{y_coord}"
        return {:x => x_coord / @@wf_col_width, :y => y_coord / @@wf_row_height}
      end


      def get_knime_node_object (node_id)
        return @nodes[node_id]
      end

      def build_workflow(dest_dir)
        prep_dir = Dir.mktmpdir("qki")
        wf_dir = "#{prep_dir}/#{@p_name}"
        # project_xml = Nokogiri::XML File.open 'lib/knime/xml_templates/.project'
        # xnode = project_xml.xpath("/projectDescription/name").first
        # xnode.content = @p_name


        FileUtils.mkdir(wf_dir);
        FileUtils.mkdir_p(dest_dir)
        # puts wf_dir

        # open("#{wf_dir}/.project", "w") {|f| f.puts(project_xml.to_xml)}

        # build node folders
        out_workflow_xml = @workflow_xml.dup
        out_workflow_xml.xpath("/xmlns:config/xmlns:config[@key='nodes']/xmlns:config").each {
          |node_dom|
          #puts 'here'
          node_id = node_dom.xpath("xmlns:entry[@key='id']/@value").first.value
          folder_name = @nodes[node_id].build_node(wf_dir, node_id)  # make the node folder
          #puts folder_name
          # update the node_settings_file settings.xml path
          node_settings_file_attr = node_dom.xpath("xmlns:entry[@key='node_settings_file']/@value").first
          node_settings_file_attr.value = folder_name + "/" + node_settings_file_attr.value
          #puts node_settings_file_attr.to_xml
        }
        open("#{wf_dir}/workflow.knime", "w") {|f| f.puts(out_workflow_xml.to_xml) }


        # make .project file
        project_template = ""
        open('lib/knime/xml_templates/_project.erb') {|f| project_template = f.to_a.join}
        project_erb = ERB.new(project_template, 0, "%<>").result(
          OpenStruct.new(:project_name => @p_name).instance_eval {binding}
        )
        open("#{wf_dir}/.project", "w") {|f| f.puts(project_erb)}
        FileUtils.cp_r(wf_dir, dest_dir)
        # puts prep_dir
        FileUtils.rm_r(prep_dir)
        #puts @project_file.to_xml
      end

    end
  end
end

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

      @@new_node_template = open('lib/knime/xml_templates/node_dom_template.erb').read
      @@new_conn_template = open('lib/knime/xml_templates/connection_dom_template.erb').read

      def initialize(project_name)
        @p_name = project_name
        @workflow_xml = Nokogiri::XML File.open 'lib/knime/xml_templates/root_workflow.knime'
        @knode_sn = 0;
        @kconn_sn = 0;
        @nodes = {};    # "#{node_id}" => {"node_id" => PhEMA::KNIME::KnimeNode}
        # data structure design: use xpath to get nodes and connections

        #puts @project_file.to_xml
      end

      def add_knime_node(knode, x = 100 + rand(1000), y = 100 + rand(1000))
        if knode.class == PhEMA::KNIME::KnimeNode
          @knode_sn ++;
          node_id = @knode_sn.to_s
          nodes_dom = @workflow_xml.xpath("/xmlns:config/xmlns:config[@key='nodes']").first

          # add a block of xml to the root workflow.knime for the new node
          #new_node_template = ""
          #open('lib/knime/xml_templates/node_dom_template.erb') {|f| new_node_template = f.to_a.join}
          new_node_xml = Nokogiri::XML ERB.new(@@new_node_template, 0, "%<>").result(
            OpenStruct.new(
              :node_id => node_id, :node_type => knode.get_knime_node_type, :node_is_meta => knode.get_knime_node_is_meta, :x => x.to_s, :y => y.to_s
            ).instance_eval {binding}
          )
          nodes_dom.add_child(new_node_xml.root)

          @nodes[node_id] = knode
          return node_id
        end
      end

      def add_knime_connection(sourceID = "", destID = "", sourcePort = "", destPort = "")
        @kconn_sn ++;
        conn_id = @kconn_sn.to_s;
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
        nodes_dom.add_child(new_conn_xml.root)
        return conn_id
      end

      def delete_node (node_id)
        # please test before use
        node_dom = @workflow_xml.xpath(
          "/xmlns:config/xmlns:config[@key='nodes']/xmlns:config[xmlns:entry[@key='id']/@value='#{node_id}']"
        ).first
        node_dom.remove    # maybe need to handle nil
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
          "xmlns:config[@key='extrainfo.node.bounds']/xmlns:config[@key='extrainfo.node.bounds']/xmlns:entry[@key='0']/@value")
        ).first
        y_attr_dom = node_dom.xpath(
          "xmlns:config[@key='extrainfo.node.bounds']/xmlns:config[@key='extrainfo.node.bounds']/xmlns:entry[@key='1']/@value")
        ).first
        x_attr_dom.value = x
        y_attr_dom.value = y
      end

      def build_workflow(dest_dir)
        prep_dir = Dir.mktmpdir("qki")
        wf_dir = "#{prep_dir}/#{@p_name}"
        # project_xml = Nokogiri::XML File.open 'lib/knime/xml_templates/.project'
        # xnode = project_xml.xpath("/projectDescription/name").first
        # xnode.content = @p_name


        FileUtils.mkdir(wf_dir);
        # puts wf_dir
        open("#{wf_dir}/workflow.knime", "w") {|f| f.puts(@workflow_xml.to_xml) }
        # open("#{wf_dir}/.project", "w") {|f| f.puts(project_xml.to_xml)}

        # build node folders
        @workflow_xml.xpath("/xmlns:config/xmlns:config[@key='nodes']/xmlns:config") {
          |node_dom|
          node_id = node_dom.xpath("xmlns:entry[@key='id']/@value").first.value
          folder_name = @nodes[node_id].build_node(wf_dir)  # make the node folder

          # update the node_settings_file settings.xml path
          node_settings_file_attr = node_dom.xpath("xmlns:entry[@key='node_settings_file']/@value").first
          node_settings_file_attr.value = folder_name + "/" + node_settings_file_attr.value

        }


        # make .project file
        project_template = ""
        open('lib/knime/xml_templates/_project.erb') {|f| project_template = f.to_a.join}
        project_erb = ERB.new(project_template, 0, "%<>").result(
          OpenStruct.new(:project_name => @p_name).instance_eval {binding}
        )
        open("#{wf_dir}/.project", "w") {|f| f.puts(project_erb)}


        FileUtils.cp_r(wf_dir, dest_dir)
        FileUtils.rm_r(prep_dir)
        #puts @project_file.to_xml
      end

    end
  end
end

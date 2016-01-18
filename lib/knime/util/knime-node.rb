require 'json'
require 'nokogiri'
require 'fileutils'

module PhEMA
  module KNIME
    class KnimeNode
      def initialize(config_path)
        config_file = File.read(config_path)
        @config_json = JSON.parse(config_file)
        #@configs = {}
        @knime_xmls = {}
        @config_json["files"].each do |k|
          @knime_xmls[k] = Nokogiri::XML File.open(@config_json["archive_path"].to_s + "/" + k.to_s)
        end             # example: archive_path: "lib/qdm-knime/node-archives/and_46"
      end

      def get_config_keys
        return @config_json["operation_names"]
      end

      def update_configs (settings = {})
        settings.each do |k, v|
          #@configs[k] = v
          op = @config_json["operations"][k]
          unless op.nil?
            xf = op["file"]
            xnode = @knime_xmls[xf].xpath(op["xpath"], op["ns"]).first
            if xnode.class == Nokogiri::XML::Attr
              xnode.value = v
            elsif xnode.class == Nokogiri::XML::Element
              xnode.content = v
            end
            #puts @knime_xmls[xf].to_xml
          end
        end
      end

      def build_node (workflow_path, node_id)
        folder_name_pre = @config_json["archive_path"].split(/\//)[-1]
        folder_name_post = folder_name_pre + "_(#{node_id})"
        while File.exists? workflow_path + "/" + folder_name_post
          folder_name_post = folder_name_post + "r"
        end
        out_dir = workflow_path + "/" + folder_name_post
        FileUtils.cp_r(@config_json["archive_path"], out_dir)

        # update setting files!!!
        @knime_xmls.each do |k, v|
          settings_path = out_dir + "/" + k
          if File.file? settings_path
            FileUtils.mv settings_path, settings_path + ".old"
          end
          File.open(settings_path, 'w') {|f| f.write(v.to_xml)}
        end

        return folder_name_post
      end

      def get_knime_node_type()
        # return node type NativeNode vs MetaNode
        return @config_json["node_type"]
      end

      def get_knime_node_is_meta()
        # return node type NativeNode vs MetaNode
        return @config_json["node_is_meta"]
      end


      def get_settings_xml(file)
        return @knime_xmls[file].to_xml
      end

    end
  end
end

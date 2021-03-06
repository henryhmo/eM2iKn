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

      def get_knime_xml(file_key = nil)
        key = file_key
        if key.nil?
          key = @config_json["files"].first()
        end
        return @knime_xmls[key]
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
              xnode.value = v.to_s
            elsif xnode.class == Nokogiri::XML::Element
              xnode.content = v.to_s
            end
            #puts @knime_xmls[xf].to_xml
          end
        end
      end

      def build_node (workflow_path, node_id)
        #puts workflow_path

        folder_name_pre = @config_json["archive_path"].split(/\//)[-1]
        folder_name_post = folder_name_pre + "_(#{node_id})"
        while File.exists? workflow_path + "/" + folder_name_post
          folder_name_post = folder_name_post + "r"
        end

        out_dir = workflow_path + "/" + folder_name_post
        #puts out_dir
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

      def i2b2?()
        return @config_json["is_i2b2"]
      end

      def get_knime_node_is_meta()
        # return node type NativeNode vs MetaNode
        return @config_json["node_is_meta"]
      end

      def get_outports_type(port)
        # "0": "patient_set",
        # "1": "encounter_set",
        # "2": "patient_count"
        return @config_json["outports"][port.to_s]
      end

      def get_all_outports()
        return @config_json["outports"].keys
      end

      def find_outport(type)
        #puts "#{type}\n"
        #puts "#{@config_json["name"]}, #{@config_json["subset"]}\n"
        kv = @config_json["outports"].find{|key,value| value.eql?(type.to_s)}
        return kv.nil? ? @config_json["outports"].keys.first : kv.first
      end

      def get_config_list()
        return @config_json["operation_names"]
      end

      def get_settings_xml(file)
        return @knime_xmls[file].to_xml
      end

    end
  end
end

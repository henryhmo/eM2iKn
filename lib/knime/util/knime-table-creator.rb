require 'json'
require 'nokogiri'
require 'fileutils'
require 'erb'
require_relative 'knime-node'

module PhEMA
  module KNIME
    class KnimeTableCreator < KnimeNode
      @@new_col_prop_template = open("lib/knime/xml_templates/table_creator_column_properties.erb").read
      @@ns = {"xmlns": "http://www.knime.org/2008/09/XMLConfig"}

      def initialize(config_path = "lib/qdm-knime/qdm-knime-guides/knime_nodes/table_creator.json")
        super
        @settings_xml = get_knime_xml()
      end

      def set_column_properties(col_key, column_name = nil, cell_class = "org.knime.core.data.def.StringCell")
        xpath = "/xmlns:config/xmlns:config[@key='model']/xmlns:config[@key='columnProperties']"
        #ns = {"xmlns": "http://www.knime.org/2008/09/XMLConfig"}
        cp_root = @settings_xml.xpath(xpath, @@ns).first
        col_name = column_name
        if col_name.nil?
          col_name = "column_#{col_key}"
        end
        # Check if the column already exists; if so, update fields only
        col_dom = cp_root.xpath("xmlns:config[@key='#{col_key}']", @@ns).first
        if col_dom.nil?
          # If not, add columns before this one (recursive)
          if col_key >= 1 && get_column_name(col_key.to_i - 1).nil?
            set_column_properties(col_key.to_i - 1)
          end
          # Add new column property
          b = binding
          cp_xml = Nokogiri::XML ERB.new(@@new_col_prop_template, 0, "%<>").result b
          cp_root.add_child(cp_xml.root)
        else # Update only
          col_name_dom = col_dom.xpath("xmlns:entry[@key='ColumnName']/@value", @@ns).first
          if col_name_dom.nil?
            raise "cannot for col_name_dom"
          else
            col_name_dom.value = col_name.to_s
          end
          # Update cell_class
          cell_class_dom = col_dom.xpath("xmlns:entry[@key='cell_class']/@value", @@ns).first
          if cell_class_dom.nil?
            raise "cannot for cell_class_dom"
          else
            cell_class_dom.value = cell_class.to_s
          end

        end

      end

      def get_column_name(col_key) # return nil is the column hasn't been created
        xpath = "/xmlns:config/xmlns:config[@key='model']/xmlns:config[@key='columnProperties']/xmlns:config[@key='#{col_key}']/xmlns:entry[@key='ColumnName']/@value"
        #ns = {"xmlns": "http://www.knime.org/2008/09/XMLConfig"}
        col_name_dom = @settings_xml.xpath(xpath, @@ns).first
        col_name = nil
        unless col_name_dom.nil?
          col_name = col_name_dom.value
        end
        # find col_name

        return col_name
      end

      def set_value(row, column, new_value = "")

        #ns = {"xmlns": "http://www.knime.org/2008/09/XMLConfig"}
        row_xpath_rt = "/xmlns:config/xmlns:config[@key='model']/xmlns:config[@key='rowIndices']"
        col_xpath_rt = "/xmlns:config/xmlns:config[@key='model']/xmlns:config[@key='columnIndices']"
        row_xpath = "/xmlns:config/xmlns:config[@key='model']/xmlns:config[@key='rowIndices']/xmlns:entry[@value='#{row}']"
        col_xpath = "/xmlns:config/xmlns:config[@key='model']/xmlns:config[@key='columnIndices']/xmlns:entry[@value='#{column}']"
        val_xpath_rt = "/xmlns:config/xmlns:config[@key='model']/xmlns:config[@key='values']"

        # Find column, create column if column does not exists
        if get_column_name(column).nil?
          set_column_properties(column)
        end

        # Find key
        val_key = nil

        @settings_xml.xpath("#{row_xpath}/@key").each do
          |row_key_dom|
          #puts row_key_dom.to_xml
          @settings_xml.xpath("#{col_xpath}/@key").each do
            |col_key_dom|
            #puts col_key_dom.to_xml
            # Compare attribute of key and not equal to "array-size"; update val_key
            if row_key_dom.value != "array-size" && row_key_dom.value == col_key_dom.value
              val_key = row_key_dom.value
            end
          end
        end


        if val_key.nil?
          # row_erb = "<entry key=\"0\" type=\"xint\" value=\"0\"/>"
          # create key if it does not exist
          # Row entry
          row_size_dom = @settings_xml.xpath("#{row_xpath_rt}/xmlns:entry[@key='array-size']/@value", @@ns).first
          row_size = row_size_dom.value.to_i
          # append new child node
          row_indices_dom = @settings_xml.xpath(row_xpath_rt, @@ns).first
          row_indices_dom.add_child(Nokogiri.XML("<entry key=\"#{row_size}\" type=\"xint\" value=\"#{row}\"/>").root)


          # Column entry
          col_size_dom = @settings_xml.xpath("#{col_xpath_rt}/xmlns:entry[@key='array-size']/@value", @@ns).first
          col_size = col_size_dom.value.to_i
          # append new child node
          col_indices_dom = @settings_xml.xpath(col_xpath_rt, @@ns).first
          col_indices_dom.add_child(Nokogiri.XML("<entry key=\"#{col_size}\" type=\"xint\" value=\"#{column}\"/>").root)


          # Value entry
          val_size_dom = @settings_xml.xpath("#{val_xpath_rt}/xmlns:entry[@key='array-size']/@value", @@ns).first
          val_size = val_size_dom.value.to_i
          # append new child node
          val_indices_dom = @settings_xml.xpath(val_xpath_rt, @@ns).first
          val_indices_dom.add_child(Nokogiri.XML("<entry key=\"#{val_size}\" type=\"xstring\" value=\"#{new_value}\"/>").root)


          # Update all the array sizes
          unless row_size == col_size && row_size == val_size
            raise "unequal array-size: row #{row_size}; col #{col_size}; val #{val_size}"
          end
          row_size_dom.value = (row_size + 1).to_s
          col_size_dom.value = (col_size + 1).to_s
          val_size_dom.value = (val_size + 1).to_s


        else
          # Update value
          val_val_dom = @settings_xml.xpath("#{val_xpath_rt}/xmlns:entry[@key='#{val_key}']/@value").first
          val_val_dom.value = new_value

        end


      end

    end
  end
end

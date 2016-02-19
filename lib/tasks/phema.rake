require 'pathname'
require 'fileutils'
require 'json'
require_relative '../eM2iKn/hqmf-to-ik'

namespace :phema do

  desc 'Parse all xml files to JSON and save them to ./tmp'
  task :generate, [:path, :name, :output_dir] do |t, args|
    raise "You must specify the HQMF XML file path to convert" unless args.path
    raise "You must specify the name of workflow that will be generated" unless args.name
    raise "You must specify an output location for the generated workflow" unless args.output_dir

    project = PhEMA::Em2iKn::HQMF_Project.new(open(args.path).read, args.name)
    workflow = project.get_knime_workflow
    workflow.build_workflow(args.output_dir)    

    puts "Generated workflow in #{args.output_dir}"
  end
end
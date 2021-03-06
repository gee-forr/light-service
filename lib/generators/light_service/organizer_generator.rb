require_relative './generator_utils'

module LightService
  module Generators
    class OrganizerGenerator < Rails::Generators::Base
      include GeneratorUtils

      argument :name, :type => :string

      class_option :dir,
                   :type => :string,
                   :default => "organizers",
                   :desc => "Path to write organizers to"

      class_option :tests,
                   :type => :boolean,
                   :default => true,
                   :desc => "Generate tests (currently only RSpec supported)"

      source_root File.expand_path('templates', __dir__)

      desc <<~DESCRIPTION
        Description:
          Will create the boilerplate for an organizer. Pass it an organizer name, e.g.
            thing_maker, or ThingMaker   - will create ThingMaker in app/organizers/thing_maker.rb
            thing/maker, or Thing::Maker - will create Thing::Maker in app/organizers/thing/maker.rb

        Options:
          Skip rspec test creation with --no-tests
          Write organizers to a specified dir with --dir="workflows". Default is "organizers" in app/organizers

        Full Example:
          rails g light_service:organizer My::Awesome::Organizer
      DESCRIPTION

      # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
      def create_organizer
        gen_vals = create_required_gen_vals_from(name)

        @module_path     = gen_vals[:module_path]
        @class_name      = gen_vals[:class_name]
        @full_class_name = gen_vals[:full_class_name]

        file_name = gen_vals[:file_name]
        file_path = gen_vals[:file_path]

        root_dir       = options.dir.downcase
        organizer_dir  = File.join('app', root_dir, *file_path)
        organizer_file = "#{organizer_dir}/#{file_name}"

        make_nested_dir(organizer_dir)
        template("organizer_template.erb", organizer_file)

        return unless must_gen_tests?

        spec_dir       = File.join('spec', root_dir, *file_path)
        spec_file_name = gen_vals[:spec_file_name]
        spec_file      = "#{spec_dir}/#{spec_file_name}"

        make_nested_dir(spec_dir)
        template("organizer_spec_template.erb", spec_file)
      end
      # rubocop:enable Metrics/MethodLength,Metrics/AbcSize
    end
  end
end

require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      # Use File.read to read in a template file (in the format views/#{controller_name}/#{template_name}.html.erb).
      template_partial_name = File.join("views", self.class.name.underscore, "#{template_name}.html.erb")
      p "template_partial_name #{template_partial_name}"

      # Create a new ERB template from the contents.      
      template_master = File.read(template_partial_name)
      p "template_master #{template_master}"
      
      # Use binding to capture the controller's instance variables.
      # Evaluate the ERB template.
      # Pass the content to render_content.      
      render_content(ERB.new(template_master).result(binding), "text/html")
    end
  end
end

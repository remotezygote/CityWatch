require 'erubis'

TemplateCache = {}
ViewPath = File.expand_path(File.dirname(__FILE__) + "/../../../views")
Layout = Proc.new {
	file_path = "#{ViewPath}/layouts/default.html.erb"
	Erubis::FastEruby.new(File.read(file_path), bufvar: '@output_buffer', filename: file_path)
}.call

module Renderer
	
	def render(*tpl)
		layout do
			render_bare(*tpl)
		end
	end
	
	def render_bare(*tpl)
		Erubis::FastEruby.new(template(*tpl), filename: template_path(*tpl)).result(binding)
	end
	
	private
	
	def layout(&block)
		Layout.result(binding)
	end
	
	def template_content(file_path)
		return "" unless file_path
		File.read(file_path)
	end
	
	def template_path(*tpl)
		tpl.map {|t| "#{view_path}/#{t}.html.erb" }.detect{|p| File.exists?(p) }
	end
	
	def template(*tpl)
		return TemplateCache[tpl.join] if TemplateCache[tpl.join]
		file_path = template_path(*tpl)
		return template_content(file_path) if CityWatch.debug?
		TemplateCache[tpl.join] ||= template_content(file_path)
	end
	
	def view_path
		ViewPath
	end
	
end
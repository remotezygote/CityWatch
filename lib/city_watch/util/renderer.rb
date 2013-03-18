module Renderer
	
	require 'erubis'
	
	def render(*tpl)
		layout do
			render_bar(*tpl)
		end
	end
	
	def render_bare(*tpl)
		Erubis::FastEruby.new(template(*tpl), filename: template_path(*tpl)).result(binding)
	end
	
	private
	
	def layout(&block)
		@layout ||= Proc.new {
			file_path = "#{view_path}/layouts/default.html.erb"
			Erubis::FastEruby.new(File.read(file_path), bufvar: '@output_buffer', filename: file_path)
		}.call
		@layout.result(binding)
	end
	
	def template_content(file_path)
		return "" unless file_path
		File.read(file_path)
	end
	
	def template_key(*keys)
		keys.inject("") {|a,k| a += k.to_s}
	end

	def template_path(*tpl)
		tpl.map {|t| "#{view_path}/#{t}.html.erb" }.detect{|p| File.exists?(p) }
	end
	
	def template(*tpl)
		return @templates[tpl.join] if @templates && @templates[tpl.join]
		file_path = template_path(*tpl)
		return template_content(file_path) if DEBUG
		@templates ||= {}
		@templates[tpl.join] ||= template_content(file_path)
	end
	
	def view_path
		File.expand_path(File.dirname(__FILE__) + "/../../../views")
	end
	
end
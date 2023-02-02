require "shale/schema"

schema_raw = File.read(File.expand_path('schemas.json', Dir.pwd))


models = Shale::Schema.from_json([schema_raw], :root_name => 'PeoSimulation')

dir = File.expand_path('classes', Dir.pwd)
FileUtils.mkdir_p(dir) unless File.directory?(dir)

models.each do |name, model|
  output_path = File.join(dir, "#{name}.rb")
  File.write(output_path, model)
end




# See:
#   - https://stackoverflow.com/a/58196376/213191
#   - https://stackoverflow.com/a/19755506/213191
#
# irb(main):005:0> $".select{|r| r.include? 'foo.rb'}
# => ["d:/foo.rb"]
# irb(main):006:0> $".delete('d:/foo.rb')
# => "d:/foo.rb"
# irb(main):007:0> $".select{|r| r.include? 'foo.rb'}
# => []
module FileFactory
  DIR = File.dirname(__FILE__)
  EXT_PATH = "../my_library"
  PATH = File.expand_path(EXT_PATH, DIR)

  def create_lib_file(klass_mod, dir = nil, version = '1')
    km = LuckyCase.pascal_case(klass_mod)
    file_name = "#{PATH}/#{dir}#{LuckyCase.snake_case(klass_mod)}.rb"
    contents = <<~CODE
      module MyLibrary
        module #{km}
          VERSION = "0.0.#{version}"
          puts "loaded MyLibrary::#{km} v\#{MyLibrary::#{km}::VERSION} from #{file_name}"
        end
      end
    CODE

    File.write(file_name, contents)
    puts "wrote MyLibrary::#{km} v0.0.#{version} to #{file_name}"
  end

  def delete_lib_file(klass_mod, dir = nil)
    km = LuckyCase.pascal_case(klass_mod)
    Object.send(:remove_const, :"MyLibrary::#{km}") rescue NameError
    $".delete(file_name)
    file_name = "#{PATH}/#{dir}#{LuckyCase.snake_case(klass_mod)}.rb"
    File.delete(file_name) if File.exist?(file_name)
  end
end

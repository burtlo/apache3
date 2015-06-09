Ohai.plugin(:Apache) do
  provides "apache/modules"

  collect_data(:default) do
    apache Mash.new
    apache[:modules] = { :static => [], :shared => [] }

    modules = shell_out("apachectl -t -D DUMP_MODULES")
    # modules.stdout.split("\n").each do |line|
    modules.stdout.each_line do |line|
      name, module_type = line.gsub("_module (",",").gsub(")","").strip.split(",")
      next if module_type.nil?
      apache[:modules][module_type.to_sym] << name
    end

    # modules = shell_out("apachectl -t -D DUMP_MODULES")
    # apache[:modules] = modules.stdout

  end

end
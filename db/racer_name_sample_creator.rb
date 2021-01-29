is_creating = false
if ARGV[0] == '--create'
  is_creating = true
  ARGV.shift
end

input_filename = ARGV[0]

unless input_filename
  STDERR.puts "Specify input file"
  exit
end

unless File.exists?(input_filename)
  STDERR.puts "Cannot open file '#{input_filename}'"
  exit
end

RE_KATAKANA_WORD = /[\p{katakana}ー]+/

names = []
File.open(input_filename, 'r') do |f|
  f.each do |line|
    names.concat(line.scan(RE_KATAKANA_WORD))
  end
end
names_already_exist, names_to_create = names.group_by { |name|
  RacerNameSample.exists?(name: name)
}.fetch_values(true, false) { [] }.map(&:uniq)

puts "Names which already exist (#{names_already_exist.size}):"
puts names_already_exist.join('、')
puts "Names to create (#{names_to_create.size}):"
puts names_to_create.join('、')

if is_creating
  begin
    RacerNameSample.transaction do
      names_to_create.each do |name|
        rns = RacerNameSample.new(name: name)
        begin
          rns.save!
        rescue ActiveRecord::RecordInvalid
          STDERR.puts "While creating with name of '#{name}'..."
          STDERR.puts rns.errors.messages
          raise
        end
      end
    end
  rescue ActiveRecord::RecordInvalid
    exit
  end
end

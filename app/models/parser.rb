module Gedcom
  class Parser
    def initialize(file)
      @file = file
    end

    # returns the parsed content
    def parse(content, open_tags, prev_level, root_level)
      File.open("#{file.path}", "r").each_line do |line|

        next if /^\s*$/ === line

        line = line.chomp.split(/\s+/, 3)
        
        level = line.shift.to_i
        
        if prev_level.nil?
          prev_level = root_level = level-1  # not assuming base level is 0
        end
        
        (level..prev_level).to_a.reverse.each do |i|
          content << "\t" * (i - root_level) if content[-1] == ?\n
          content << "</#{open_tags.pop}>\n"
        end
        
        if line[0][0] == ?@
          xref_id, tag = line
          xref_id.gsub!(/^@(.*)@$/, '\1')
          id_attr = ' id="' + xref_id + '"'
          value = ''
        else
          tag, value = line
          id_attr = ''
          value ||= ''
          if /^@(\w+)@$/ === value
            value = "<xref>#{$1}</xref>"
          else
            value.gsub!(/&/, '&amp;')
            value.gsub!(/</, '&lt;')
            value.gsub!(/>/, '&gt;')
          end
        end
        
        if tag == 'CONC' || tag == 'CONT'
          content << (tag == 'CONT' ? "\n" : " ")
          content << value
          level -= 1
        else
          content << "\n" if level > prev_level
          tag.downcase!
          content << "\t" * (level - root_level) + "<#{tag}#{id_attr}>#{value}"
          open_tags.push tag
        end
        
        prev_level = level
      end
      content
    end

    private

    def file
      @file
    end
  end
end

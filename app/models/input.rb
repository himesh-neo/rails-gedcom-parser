require 'parser'

class Input < ActiveRecord::Base
  mount_uploader :file, FileUploader

  include Gedcom

  # returns the xml content
  # input => file
  # output => xml xontent
  # scope => public
  def to_xml(file)
    content = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<gedcom>"

    open_tags = ["gedcom"]

    prev_level = root_level = nil

    parser = Gedcom::Parser.new(file)
    content = parser.parse(content, open_tags, prev_level, root_level)

    while tag = open_tags.pop
      content << "\t" * (open_tags.length) + "</#{tag}>\n"
    end

    content
  end
end

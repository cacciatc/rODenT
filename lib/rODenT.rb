#Copyright (c) 2010 Chris Cacciatore
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

require 'rubygems'
require 'nokogiri'
require 'zip/zipfilesystem'


class Rodent
  include Nokogiri, Zip
  attr_accessor :file_string
  
  OR    = '|'
  PARA  = 'text:p'
  LIST  = 'text:list'
  
  TABLE = 'table:table'
  TABLE_ROW  = 'table:table-column'
  TABLE_COL  = 'table:table-row'
  TABLE_CELL = 'table:table-cell'
  
  DOC   = 'office:document-content/office:body/office:text/'
  def initialize(file_name)
    odt = ZipFile.open(file_name)
    @content_xml = XML::parse(odt.read('content.xml'))
    @lists,@paras,@tables = [],[],[]
    #inject was giving funny behavior...so looping explicitly
    i = 1
    @content_xml.xpath("#{DOC} #{PARA} #{OR} 
                        #{DOC} #{LIST} #{OR}
                        #{DOC} #{TABLE}").each do |node|
      #got to be a better way to do this...
      case node.to_s
        when /^<text:p/
          @paras  << {:node=>node.text,:ord=>i}
        when /^<text:list/
          @lists  << {:node=>node.text,:ord=>i}
        when /^<table:table/
          @tables << {:node=>node.text,:ord=>i}
        end
        i += 1
    end
  end
  def self.scurry(string,&b)
    if not block_given?
      Rodent.new(string)
    else
      yield Rodent.new(string)
    end
  end
  def paragraphs(&b)
    if block_given?
      yield @paras
    else
      @paras
    end
  end
  def lists(&b)
    if block_given?
      yield @lists
    else
      @lists
    end
  end
  def footnotes
    Rodent.footnotes(@content_xml)
  end
  def tables
    if block_given?
      yield @tables
    else
      @tables
    end
  end
  private :initialize
end
class Rat < Rodent;end
class Mouse < Rodent;end
class SmallFurryThing < Rodent;end
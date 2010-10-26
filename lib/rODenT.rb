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
  TAB   = 'text:tab'
  PARA  = 'text:p'
  SPAN  = 'text:span'
  
  LIST      = 'text:list'
  LIST_ITEM = 'text:list-item/text:p'
  
  TABLE      = 'table:table'
  TABLE_ROW  = 'table:table-row'
  TABLE_COL  = 'table:table-col'
  TABLE_CELL = 'table:table-cell'
  
  DOC_STYLES = 'office:document-content/office:automatic-styles/style:style'
  
  DOC   = 'office:document-content/office:body/office:text/'
  STYLE = 'office:document-styles/office:master-styles/style:master-page/style:footer'
  
  def initialize(file_name)
    odt = ZipFile.open(file_name)
    content_xml = XML::parse(odt.read('content.xml'))
    styles_xml  = XML::parse(odt.read('styles.xml'))
    
    resolved_styles = preprocess_styles(content_xml)
    @lists,@paras,@tables,@footnotes = [],[],[],[]
    
    #inject was giving funny behavior...so looping explicitly
    i = 1
    content_xml.xpath("#{DOC} #{PARA} #{OR} 
                       #{DOC} #{LIST} #{OR}
                       #{DOC} #{TABLE}").each do |node|
      
      node = substitute_styles(node,resolved_styles)
      #got to be a better way to do this...
      case node.to_s
        when /^<text:p/
          @paras  << {:node=>node.text,:ord=>i}
        when /^<text:list/
          @lists  << {:node=>node.xpath(LIST_ITEM).collect {|n| n.text},:ord=>i}
        when /^<table:table/
          @tables << {:node=>node.xpath(TABLE_ROW).collect do |row| 
            row.xpath("#{TABLE_CELL}/#{PARA}").collect do |n|
              n.text
            end
          end,:ord=>i}
        end
        i += 1
      end
    styles_xml.xpath(STYLE).each do |node|
      @footnotes << {:node=>node.text}
    end
  end
  def self.guarded(param,&b)
    if block_given?
      yield param
    else
      param
    end
  end
  def self.scurry(string,&b)
    Rodent.guarded(Rodent.new(string),&b)
  end
  def paragraphs(&b)
    Rodent.guarded(@paras,&b)
  end
  def lists(&b)
    Rodent.guarded(@lists,&b)
  end
  def footnotes(&b)
    Rodent.guarded(@footnotes,&b)
  end
  def tables(&b)
    Rodent.guarded(@tables,&b)
  end
  def preprocess_styles(content_xml)
    styles = {}
    content_xml.xpath(DOC_STYLES).each do |node|
      if node.attributes['family'].text == "text"
        styles[node.attributes['name'].text] = []
        node.xpath('style:text-properties').each do |n|
          if n.attributes['font-style']
            styles[node.attributes['name'].text] << %q{"<i>#{content}</i>"}
          end
          if n.attributes['font-weight']
            styles[node.attributes['name'].text] << %q{"<b>#{content}</b>"}
          end
          if n.attributes['text-underline-style']
            styles[node.attributes['name'].text] << %q{"<u>#{content}</u>"}
          end
        end
      end
    end
    styles
  end
  #also does whitespace like tabs
  def substitute_styles(node,styles)
    node.xpath("#{TAB} #{OR} #{SPAN}").each do |n|
      case n.to_s
        when /^<text:tab/
          n.content = "     "
        when /^<text:span/
          styles[n.attributes['style-name'].text].each do |s|
            content = n.content
            n.content = eval(s)
          end
      end
    end
    node
  end
  private :initialize, :preprocess_styles, :substitute_styles
end
class Rat < Rodent;end
class Mouse < Rodent;end
class SmallFurryThing < Rodent;end
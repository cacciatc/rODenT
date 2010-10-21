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


class Whiskers
  include Nokogiri, Zip
  attr_accessor :file_string
  
  def initialize(file_name)
    odt = ZipFile.open(file_name)
    @content_xml = XML::parse(odt.read('content.xml'))
  end
  def self.scurry(string,&b)
    yield Whiskers.new(string)
  end
  def paragraphs
    Whiskers.paragraphs(@content_xml)
  end
  def lists
    Whiskers.lists(@content_xml)
  end
  def footnotes
    Whiskers.footnotes(@content_xml)
  end
  def self.paragraphs(xml)
    xml.xpath('office:document-content/office:body/office:text/text:p')
  end
  def self.lists(xml)
    xml.xpath('office:document-content/office:body/office:text/text:list')
  end
  def self.footnotes(xml)
  end
  private :initialize
end

Whiskers.scurry 'test/test.odt' do |rat|
  puts rat.lists
  puts rat.paragraphs
end
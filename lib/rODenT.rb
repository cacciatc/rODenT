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
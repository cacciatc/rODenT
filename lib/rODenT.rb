class Whiskers
  attr_accessor :file_string
  def initialize(file_string)
    @file_string = file_string
  end
  def self.scurry(string,&b)
    yield Whiskers.new(string)
  end
  def paragraphs
    Whiskers.paragraphs(@file_string)
  end
  def lists
    Whiskers.lists(@file_string)
  end
  def footnotes
    Whiskers.footnotes(@file_string)
  end
  def self.paragraphs(string)
    
  end
  def self.lists(string)
    
  end
  def self.footnotes(string)
    
  end
  private :initialize
end
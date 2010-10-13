require 'rODenT'

describe "rODent" do
  describe Whiskers do
    it "should list paragraphs" do
      Whiskers.paragraphs('')
      fail
    end
    it "should list lists" do
      Whiskers.lists('')
      fail
    end
    it "should list footnotes" do
      Whiskers.footnotes('')
      fail
    end
  end
end
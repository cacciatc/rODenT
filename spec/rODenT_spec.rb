require 'rODenT'

describe "rODent's" do
  describe Rat do
    it "should list paragraphs" do
      rat = Rat.scurry('test\test.odt') 
      rat.paragraphs.empty?.should == false
    end
    it "should list lists" do
      rat = Rat.scurry('test\test.odt') 
      rat.lists.empty?.should == false
    end
    it "should list footnotes" do
      fail
    end
  end
end
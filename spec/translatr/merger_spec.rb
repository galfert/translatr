require 'spec_helper'

module Translatr
  describe Merger do
    before(:each) do
      @merger = Translatr::Merger.new
      fixture_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'fixtures')
      @target_path = File.join(fixture_path, 'target.yml').to_s
      @source_path = File.join(fixture_path, 'source.yml').to_s
    end

    describe "#load_target" do
      it "should set the target filename" do
        @merger.load_target @target_path
        @merger.target_filename.should == @target_path
      end

      it "should load the file into target" do
        @merger.load_target @target_path
        @merger.target.should == { "foo" => "bar" }
      end
    end

    describe "#load_source" do
      it "should set the source filename" do
        @merger.load_source @source_path
        @merger.source_filename.should == @source_path
      end

      it "should load the file into source" do
        @merger.load_source @source_path
        @merger.source.should == { "foo" => "baz" }
      end
    end

    describe "#merge" do
      it "should merge source into target" do
        @merger.load_target @target_path
        @merger.load_source @source_path

        @merger.merge.should == { "foo" => "baz" }
      end

      it "should overwrite entries in target that are different in source" do
        @merger.target = { "foo" => "target" }
        @merger.source = { "foo" => "source" }
        @merger.merge.should == { "foo" => "source" }
      end

      it "should keep entries in target that are not in source" do
        @merger.target = { "foo" => "target", "bar" => "baz" }
        @merger.source = { "foo" => "source" }
        @merger.merge.should == { "foo" => "source", "bar" => "baz" }
      end

      it "should ignore entries that are in source but not in target" do
        @merger.target = { "foo" => "target" }
        @merger.source = { "foo" => "source", "bar" => "baz" }
        @merger.merge.should == { "foo" => "source" }
      end

      it "should work with multidimensional entries" do
        pending "maybe use http://api.rubyonrails.org/v2.3.8/classes/ActiveSupport/CoreExtensions/Hash/DeepMerge.html"
        @merger.target = { "foo" => "target", "bar" => { "baz" => "beng", "wuz" => "up" } }
        @merger.source = { "foo" => "source", "bar" => { "baz" => "pong" } }
        @merger.merge.should == { "foo" => "source", "bar" => { "baz" => "pong", "wuz" => "up" } }
      end


      it "should skip the root key"

      it "should ignore entries with variable mismatch"

      it "should ignore entries with markup when target has none and key doesn't end with '_html'"
    end
  end
end

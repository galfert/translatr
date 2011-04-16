require 'spec_helper'

module Translatr
  describe Merger do
    let(:merger) { Translatr::Merger.new }
    let(:fixture_path) { File.join(File.expand_path(File.dirname(__FILE__)), '..', 'fixtures') }
    let(:target_path) { File.join(fixture_path, 'target.yml').to_s }
    let(:source_path) { File.join(fixture_path, 'source.yml').to_s }

    describe "#load_target" do
      before do
        merger.load_target target_path
      end

      it "sets the target filename" do
        merger.target_filename.should == target_path
      end

      it "loads the file into target" do
        merger.target.should == { "foo" => "bar" }
      end
    end

    describe "#load_source" do
      before do
        merger.load_source source_path
      end

      it "sets the source filename" do
        merger.source_filename.should == source_path
      end

      it "loads the file into source" do
        merger.source.should == { "foo" => "baz" }
      end
    end

    describe "#merge" do
      it "merges source into target" do
        merger.load_target target_path
        merger.load_source source_path

        merger.merge.should == { "foo" => "baz" }
      end

      it "overwrites entries in target that are different in source" do
        merger.target = { "foo" => "target" }
        merger.source = { "foo" => "source" }
        merger.merge.should == { "foo" => "source" }
      end

      it "keeps entries in target that are not in source" do
        merger.target = { "foo" => "target", "bar" => "baz" }
        merger.source = { "foo" => "source" }
        merger.merge.should == { "foo" => "source", "bar" => "baz" }
      end

      it "ignores entries that are in source but not in target" do
        merger.target = { "foo" => "target" }
        merger.source = { "foo" => "source", "bar" => "baz" }
        merger.merge.should == { "foo" => "source" }
      end

      it "works with multidimensional entries" do
        pending "maybe use http://api.rubyonrails.org/v2.3.8/classes/ActiveSupport/CoreExtensions/Hash/DeepMerge.html"
        merger.target = { "foo" => "target", "bar" => { "baz" => "beng", "wuz" => "up" } }
        merger.source = { "foo" => "source", "bar" => { "baz" => "pong" } }
        merger.merge.should == { "foo" => "source", "bar" => { "baz" => "pong", "wuz" => "up" } }
      end

      it "skips the locale name (root key)"

      it "ignores entries with variable mismatch"

      it "ignores entries with markup when target has none and key doesn't end with '_html'"
    end
  end
end

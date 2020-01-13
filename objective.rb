class Objective
  LOCK_STATUSES = {
    :unlocked  => 0,
    :uploading => 1,
    :locked    => 2
  }
    
  def locked?
    locked_by.present? &&
    [LOCK_STATUSES[:uploading], LOCK_STATUSES[:locked]].include?(lock_status)
  end
  
  def release_lock
    assign_attributes(
      :locked_by => nil,
      :locked_on_name => nil,
      :locked_on_id => nil,
      :lock_status => LOCK_STATUSES[:unlocked]
    )
  end
end

require "rails_helper"

describe Objective do
  subject { described_class.new }

  describe "#locked?" do
    context "when locked_by don't present" do
      let(:locked_by) { nil }

      it "return false" do
        
        expect(subject.locked?).to false
      end
    end

    context "when lock_status is unlocked" do
      let(:lock_status) { :unlocked }

      it "return false" do
        expect(subject.locked?).to false
      end
    end

    context "when locked_by present and lock_status is unlocked" do
      let(:locked_by) { "Name" }
      let(:lock_status) { :unlocked }

      it "return false" do
        expect(subject.locked?).to false
      end
    end

    context "when locked_by present and lock_status is locked" do
      let(:locked_by) { "Name" }
      let(:lock_status) { :unlocked }

      it "return true" do
        expect(subject.locked?).to true
      end
    end
  end

  describe "#release_lock" do
    let(:attributes) do
      {
      :locked_by => nil,
      :locked_on_name => nil,
      :locked_on_id => nil,
      :lock_status => LOCK_STATUSES[:unlocked]
      }
    end
    let(:objective) { FactoryGirl.attributes_for(:subject, :attributes) }

    it "assign attributes" do
      expect(assigns(:objective).locked_by).to eq nil
      expect(assigns(:objective).locked_on_name).to eq nil
      expect(assigns(:objective).locked_on_id).to eq nil
      expect(assigns(:objective).lock_status).to eq LOCK_STATUSES[:unlocked]
    end
  end
end

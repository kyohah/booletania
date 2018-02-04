require 'spec_helper'

class Invitation < ActiveRecord::Base
  include Booletania
end

# not AR
class NotActiveRecord
  def initialize
    self.class.__send__(:include, Booletania)
  end
end

describe Booletania do
  it 'has a version number' do
    expect(Booletania::VERSION).not_to be nil
  end

  context "don't extend AR" do
    subject { NotActiveRecord.new }

    it 'raise ArgumentError' do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  describe "#_text" do
    let!(:invitation) { Invitation.create(accepted1: accepted1) }
    after { Invitation.delete_all }

    subject { invitation.accepted1_text }

    context "lang is ja" do
      before { I18n.locale = :ja }

      context "column is true" do
        let(:accepted1) { true }

        it { is_expected.to eq '承諾' }
      end

      context "column is false" do
        let(:accepted1) { false }

        it { is_expected.to eq '拒否' }
      end
    end

    context "lang is en" do
      before { I18n.locale = :en }

      context "column is true" do
        let(:accepted1) { true }

        it { is_expected.to eq 'accept' }
      end

      context "column is false" do
        let(:accepted1) { false }

        it { is_expected.to eq 'deny' }
      end
    end
  end

  describe "._options" do
    subject { Invitation.accepted1_options }

    context "lang is ja" do
      before { I18n.locale = :ja }

      it { is_expected.to eq [['承諾', true], ['拒否', false]] }
    end

    context "lang is en" do
      before { I18n.locale = :en }

      it { is_expected.to eq [['accept', true], ['deny', false]] }
    end

    context "lans is invalid" do
      before { I18n.locale = :xx }

      it { is_expected.to eq [] }
    end
  end
end

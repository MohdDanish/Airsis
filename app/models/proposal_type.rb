class ProposalType < ApplicationRecord
  has_many :proposals, class_name: 'Proposal'

  SIMPLE = 'SIMPLE'.freeze
  STANDARD = 'STANDARD'.freeze
  POLL = 'POLL'.freeze
  RULE_BOOK = 'RULE_BOOK'.freeze
  PRESS = 'PRESS'.freeze
  EVENT = 'EVENT'.freeze
  ESTIMATE = 'ESTIMATE'.freeze
  AGENDA = 'AGENDA'.freeze
  CANDIDATE = 'CANDIDATE'.freeze
  PETITION = 'PETITION'.freeze

  scope :active, -> { where(active: true) }

  scope :for_groups, -> { where(groups_available: true) }

  scope :for_open_space, -> { where(open_space_available: true) }

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{name}.description")
  end

  def self.for_menu(group)
    joins = "join proposals on proposals.proposal_type_id = proposal_types.id
                            join group_proposals on proposals.id = group_proposals.proposal_id"
    conditions = " group_proposals.group_id = #{group.id} and proposals.private = 't'"
    types = ProposalType.joins(joins).where(conditions).group(ProposalType.column_names.map { |col| "#{ProposalType.table_name}.#{col}" }.join(','))
  end
end

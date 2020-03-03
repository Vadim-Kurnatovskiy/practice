def source_procedure_label(object)
  audit = object.audit || current_audit
  target_key = object.target.class.name.underscore

  case object.target
  when Objective, Finding
    h(audit.term_for_objective)
  when Control
    h(audit.term_for_control)
  when Narrative
    h(audit.term_for_narrative)
  when Walkthrough
    h(audit.term_for_walkthrough)
  when ProcessWalkthrough
    h(audit.term_for_process_walkthrough)
  when RiskControlMatrix
    h(audit.term_for_risk_control_matrix)
  else
    t("app.source_procedure.#{target_key}", :term_for_project => audit.term_for_project)
  end
end

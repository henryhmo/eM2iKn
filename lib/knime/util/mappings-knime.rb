module PhEMA
  module KNIME
    DER_KNIME_MAPPING = [
      { :id => "http://rdf.healthit.gov/qdm/element#CareGoal", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "CareGoal", :description => "Care Goal"},

      { :id => "http://rdf.healthit.gov/qdm/element#CommunicationFromPatienttoProvider", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "CommunicationFromPatienttoProvider", :description => "Communication, From Patient to Provider"},
      { :id => "http://rdf.healthit.gov/qdm/element#CommunicationFromProvidertoPatient", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "CommunicationFromProvidertoPatient", :description => "Communication, From Provider to Patient"},
      { :id => "http://rdf.healthit.gov/qdm/element#CommunicationFromProvidertoProvider", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "CommunicationFromProvidertoProvider", :description => "Communication, From Provider to Provider"},

      { :id => "http://rdf.healthit.gov/qdm/element#DeviceAdverseEvent", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DeviceAdverseEvent", :description => "Device, Adverse Event"},
      { :id => "http://rdf.healthit.gov/qdm/element#DeviceAllergy", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DeviceAllergy", :description => "Device, Allergy"},
      { :id => "http://rdf.healthit.gov/qdm/element#DeviceApplied", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DeviceApplied", :description => "Device, Applied"},
      { :id => "http://rdf.healthit.gov/qdm/element#DeviceIntolerance", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DeviceIntolerance", :description => "Device, Intolerance"},
      { :id => "http://rdf.healthit.gov/qdm/element#DeviceOrder", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DeviceOrder", :description => "Device, Order"},
      { :id => "http://rdf.healthit.gov/qdm/element#DeviceRecommended", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DeviceRecommended", :description => "Device, Recommended"},

      { :id => "http://rdf.healthit.gov/qdm/element#DiagnosisActive", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DiagnosisActive", :description => "Diagnosis, Active"},
      { :id => "http://rdf.healthit.gov/qdm/element#DiagnosisFamilyHistory", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DiagnosisFamilyHistory", :description => "Diagnosis, Family History"},
      { :id => "http://rdf.healthit.gov/qdm/element#DiagnosisInactive", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DiagnosisInactive", :description => "Diagnosis, Inactive"},
      { :id => "http://rdf.healthit.gov/qdm/element#DiagnosisResolved", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DiagnosisResolved", :description => "Diagnosis, Resolved"},

      { :id => "http://rdf.healthit.gov/qdm/element#DiagnosticStudyAdverseEvent", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DiagnosticStudyAdverseEvent", :description => "Diagnostic Study, Adverse Event"},
      { :id => "http://rdf.healthit.gov/qdm/element#DiagnosticStudyIntolerance", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DiagnosticStudyIntolerance", :description => "Diagnostic Study, Intolerance"},
      { :id => "http://rdf.healthit.gov/qdm/element#DiagnosticStudyOrder", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DiagnosticStudyOrder", :description => "Diagnostic Study, Order"},
      { :id => "http://rdf.healthit.gov/qdm/element#DiagnosticStudyPerformed", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DiagnosticStudyPerformed", :description => "Diagnostic Study, Performed"},
      { :id => "http://rdf.healthit.gov/qdm/element#DiagnosticStudyRecommended", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "DiagnosticStudyRecommended", :description => "Diagnostic Study, Recommended"},

      { :id => "http://rdf.healthit.gov/qdm/element#EncounterActive", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "EncounterActive", :description => "Encounter, Active"},
      { :id => "http://rdf.healthit.gov/qdm/element#EncounterOrder", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "EncounterOrder", :description => "Encounter, Order"},
      { :id => "http://rdf.healthit.gov/qdm/element#EncounterPerformed", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "EncounterPerformed", :description => "Encounter, Performed"},
      { :id => "http://rdf.healthit.gov/qdm/element#EncounterRecommended", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "EncounterRecommended", :description => "Encounter, Recommended"},

      { :id => "http://rdf.healthit.gov/qdm/element#FunctionalStatusOrder", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "FunctionalStatusOrder", :description => "Functional Status, Order"},
      { :id => "http://rdf.healthit.gov/qdm/element#FunctionalStatusPerformed", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "FunctionalStatusPerformed", :description => "Functional Status, Performed"},
      { :id => "http://rdf.healthit.gov/qdm/element#FunctionalStatusRecommended", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "FunctionalStatusRecommended", :description => "Functional Status, Recommended"},

      { :id => "http://rdf.healthit.gov/qdm/element#InterventionAdverseEvent", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "InterventionAdverseEvent", :description => "Intervention, Adverse Event"},
      { :id => "http://rdf.healthit.gov/qdm/element#InterventionIntolerance", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "InterventionIntolerance", :description => "Intervention, Intolerance"},
      { :id => "http://rdf.healthit.gov/qdm/element#InterventionOrder", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "InterventionOrder", :description => "Intervention, Order"},
      { :id => "http://rdf.healthit.gov/qdm/element#InterventionPerformed", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "InterventionPerformed", :description => "Intervention, Performed"},
      { :id => "http://rdf.healthit.gov/qdm/element#InterventionRecommended", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "InterventionRecommended", :description => "Intervention, Recommended"},

      { :id => "http://rdf.healthit.gov/qdm/element#LaboratoryTestAdverseEvent", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "LaboratoryTestAdverseEvent", :description => "Laboratory Test, Adverse Event"},
      { :id => "http://rdf.healthit.gov/qdm/element#LaboratoryTestIntolerance", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "LaboratoryTestIntolerance", :description => "Laboratory Test, Intolerance"},
      { :id => "http://rdf.healthit.gov/qdm/element#LaboratoryTestOrder", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "LaboratoryTestOrder", :description => "Laboratory Test, Order"},
      { :id => "http://rdf.healthit.gov/qdm/element#LaboratoryTestPerformed", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_lab.json", :name => "LaboratoryTestPerformed", :description => "Laboratory Test, Performed"},
      { :id => "http://rdf.healthit.gov/qdm/element#LaboratoryTestRecommended", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "LaboratoryTestRecommended", :description => "Laboratory Test, Recommended"},

      { :id => "http://rdf.healthit.gov/qdm/element#MedicationActive", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "MedicationActive", :description => "Medication, Active"},
      { :id => "http://rdf.healthit.gov/qdm/element#MedicationAdministered", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "MedicationAdministered", :description => "Medication, Administered"},
      { :id => "http://rdf.healthit.gov/qdm/element#MedicationAdverseEffects", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "MedicationAdverseEffects", :description => "Medication, Adverse Effects"},
      { :id => "http://rdf.healthit.gov/qdm/element#MedicationAllergy", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "MedicationAllergy", :description => "Medication, Allergy"},
      { :id => "http://rdf.healthit.gov/qdm/element#MedicationDischarge", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "MedicationDischarge", :description => "Medication, Discharge"},
      { :id => "http://rdf.healthit.gov/qdm/element#MedicationDispensed", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "MedicationDispensed", :description => "Medication, Dispensed"},
      { :id => "http://rdf.healthit.gov/qdm/element#MedicationIntolerance", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "MedicationIntolerance", :description => "Medication, Intolerance"},
      { :id => "http://rdf.healthit.gov/qdm/element#MedicationOrder", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "MedicationOrder", :description => "Medication, Order"},

      { :id => "http://rdf.healthit.gov/qdm/element#PatientCareExperience", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PatientCareExperience", :description => "Patient Care Experience"},

      { :id => "http://rdf.healthit.gov/qdm/element#PatientCharacteristic", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PatientCharacteristic", :description => "Patient Characteristic"},
      { :id => "http://rdf.healthit.gov/qdm/element#PatientCharacteristicBirthdate", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PatientCharacteristicBirthdate", :description => "Patient Characteristic, Birthdate"},
      { :id => "http://rdf.healthit.gov/qdm/element#PatientCharacteristicClinicalTrialParticipant", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PatientCharacteristicClinicalTrialParticipant", :description => "Patient Characteristic, Clinical Trial Participant"},
      { :id => "http://rdf.healthit.gov/qdm/element#PatientCharacteristicEthnicity", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PatientCharacteristicEthnicity", :description => "Patient Characteristic, Ethnicity"},
      { :id => "http://rdf.healthit.gov/qdm/element#PatientCharacteristicExpired", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PatientCharacteristicExpired", :description => "Patient Characteristic, Expired"},
      { :id => "http://rdf.healthit.gov/qdm/element#PatientCharacteristicPayer", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PatientCharacteristicPayer", :description => "Patient Characteristic, Payer"},
      { :id => "http://rdf.healthit.gov/qdm/element#PatientCharacteristicRace", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PatientCharacteristicRace", :description => "Patient Characteristic, Race"},
      { :id => "http://rdf.healthit.gov/qdm/element#PatientCharacteristicSex", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PatientCharacteristicSex", :description => "Patient Characteristic, Sex"},

      { :id => "http://rdf.healthit.gov/qdm/element#PhysicalExamOrder", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PhysicalExamOrder", :description => "Physical Exam, Order"},
      { :id => "http://rdf.healthit.gov/qdm/element#PhysicalExamPerformed", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PhysicalExamPerformed", :description => "Physical Exam, Performed"},
      { :id => "http://rdf.healthit.gov/qdm/element#PhysicalExamRecommended", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "PhysicalExamRecommended", :description => "Physical Exam, Recommended"},

      { :id => "http://rdf.healthit.gov/qdm/element#ProcedureAdverseEvent", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "ProcedureAdverseEvent", :description => "Procedure, Adverse Event"},
      { :id => "http://rdf.healthit.gov/qdm/element#ProcedureIntolerance", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "ProcedureIntolerance", :description => "Procedure, Intolerance"},
      { :id => "http://rdf.healthit.gov/qdm/element#ProcedureOrder", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "ProcedureOrder", :description => "Procedure, Order"},
      { :id => "http://rdf.healthit.gov/qdm/element#ProcedurePerformed", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "ProcedurePerformed", :description => "Procedure, Performed"},
      { :id => "http://rdf.healthit.gov/qdm/element#ProcedureRecommended", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "ProcedureRecommended", :description => "Procedure, Recommended"},

      { :id => "http://rdf.healthit.gov/qdm/element#ProviderCareExperience", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "ProviderCareExperience", :description => "Provider Care Experience"},

      { :id => "http://rdf.healthit.gov/qdm/element#ProviderCharacteristic", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "ProviderCharacteristic", :description => "Provider Characteristic"},

      { :id => "http://rdf.healthit.gov/qdm/element#RiskCategoryAssessment", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "RiskCategoryAssessment", :description => "Risk Category/Assessment"},

      { :id => "http://rdf.healthit.gov/qdm/element#SubstanceAdministered", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "SubstanceAdministered", :description => "Substance, Administered"},
      { :id => "http://rdf.healthit.gov/qdm/element#SubstanceAdverseEvent", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "SubstanceAdverseEvent", :description => "Substance, Adverse Event"},
      { :id => "http://rdf.healthit.gov/qdm/element#SubstanceAllergy", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "SubstanceAllergy", :description => "Substance, Allergy"},
      { :id => "http://rdf.healthit.gov/qdm/element#SubstanceIntolerance", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "SubstanceIntolerance", :description => "Substance, Intolerance"},
      { :id => "http://rdf.healthit.gov/qdm/element#SubstanceOder", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "SubstanceOrder", :description => "Substance, Order"},
      { :id => "http://rdf.healthit.gov/qdm/element#SubstanceRecommended", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "SubstanceRecommended", :description => "Substance, Recommended"},

      { :id => "http://rdf.healthit.gov/qdm/element#SymptomActive", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "SymptomActive", :description => "Symptom, Active"},
      { :id => "http://rdf.healthit.gov/qdm/element#SymptomAssessed", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "SymptomAssessed", :description => "Symptom, Assessed"},
      { :id => "http://rdf.healthit.gov/qdm/element#SymptomInactive", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "SymptomInactive", :description => "Symptom, Inactive"},
      { :id => "http://rdf.healthit.gov/qdm/element#SymptomResolved", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "SymptomResolved", :description => "Symptom, Resolved"},

      { :id => "http://rdf.healthit.gov/qdm/element#TransferFrom", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "TransferFrom", :description => "Transfer From"},
      { :id => "http://rdf.healthit.gov/qdm/element#TransferTo", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Data_Elements/dataElement_nonLab.json", :name => "TransferTo", :description => "Transfer To"},
      { :id => "http://rdf.healthit.gov/qdm/element#SatisfiesAll", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Groupings/allTrue.json", :name => "SatisfiesAll", :description => "Satisfies All"},
      { :id => "http://rdf.healthit.gov/qdm/element#SatisfiesAny", :knime_cofig => "lib/qdm-knime/qdm-knime-guides/Groupings/atLeastOneTrue.json", :name => "SatisfiesAny", :description => "Satisfies Any"}

    ]

    QDM_KNIME_LOGICAL_CONJUNCTION_MAPPING = {
      "allTrue" => {
        "config_path" => "lib/qdm-knime/qdm-knime-guides/Groupings/allTrue.json",
        "configs" => {"invert" => "0"}
      },
      "atLeastOneTrue" => {
        "config_path" => "lib/qdm-knime/qdm-knime-guides/Groupings/atLeastOneTrue.json",
        "configs" => {"invert" => "0"}
      },
      "allFalse" => {
        "config_path" => "lib/qdm-knime/qdm-knime-guides/Groupings/allTrue.json",
        "configs" => {"invert" => "1"}
      }
    }

    QDM_KNIME_TEMPORAL_MAPPING = {
      "EAE" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "SAEORSCWE" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "EDU" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationSpan.json",
      "SBEORSCWE" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "ECWS" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "SDU" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationSpan.json",
      "SASORSCW" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "SAS" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "EBE" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "EBEORECW" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "EBS" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "DURING" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationSpan.json",
      "EASORECWS" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "SAE" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "SBE" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "SBS" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "SBSORSCW" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "EAEORECW" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "SCWE" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "EAS" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "EBSORECWS" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "ECW" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "SCW" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationPoint.json",
      "CONCURRENT" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationSpan.json",
      "OVERLAP" => "lib/qdm-knime/qdm-knime-guides/Temporals/temporalInformationSpan.json"
    }

    I2B2_QDM_KNIME_TEMPORAL_CONFIGS ={
      "SBS" => {
        "temporal_operator" => "LESS",
        "join_column_left" => "STARTDATE",
        "join_column_right" => "STARTDATE"
      },
      "SBSORSCW" => {
        "temporal_operator" => "LESSEQUAL",
        "join_column_left" => "STARTDATE",
        "join_column_right" => "STARTDATE"
      },
      "SBE" => {
        "temporal_operator" => "LESS",
        "join_column_left" => "STARTDATE",
        "join_column_right" => "ENDDATE"
      },
      "SBEORSCWE" => {
        "temporal_operator" => "LESSEQUAL",
        "join_column_left" => "STARTDATE",
        "join_column_right" => "ENDDATE"
      },
      "SAS" => {
        "temporal_operator" => "GREATER",
        "join_column_left" => "STARTDATE",
        "join_column_right" => "STARTDATE"
      },
      "SASORSCW" => {
        "temporal_operator" => "GREATEREQUAL",
        "join_column_left" => "STARTDATE",
        "join_column_right" => "STARTDATE"
      },
      "SAEORSCWE" => {
        "temporal_operator" => "GREATEREQUAL",
        "join_column_left" => "STARTDATE",
        "join_column_right" => "ENDDATE"
      },
      "SAE" => {
        "temporal_operator" => "GREATER",
        "join_column_left" => "STARTDATE",
        "join_column_right" => "ENDDATE"
      },
      "SCW" => {
        "temporal_operator" => "EQUAL",
        "join_column_left" => "STARTDATE",
        "join_column_right" => "STARTDATE"
      },
      "SCWE" => {
        "temporal_operator" => "EQUAL",
        "join_column_left" => "STARTDATE",
        "join_column_right" => "ENDDATE"
      },

      "EBS" => {
        "temporal_operator" => "LESS",
        "join_column_left" => "ENDDATE",
        "join_column_right" => "STARTDATE"
      },
      "EBSORECWS" => {
        "temporal_operator" => "LESSEQUAL",
        "join_column_left" => "ENDDATE",
        "join_column_right" => "STARTDATE"
      },
      "EAS" => {
        "temporal_operator" => "GREATER",
        "join_column_left" => "ENDDATE",
        "join_column_right" => "STARTDATE"
      },
      "EASORECWS" => {
        "temporal_operator" => "GREATEREQUAL",
        "join_column_left" => "ENDDATE",
        "join_column_right" => "STARTDATE"
      },
      "EAE" => {
        "temporal_operator" => "GREATER",
        "join_column_left" => "ENDDATE",
        "join_column_right" => "ENDDATE"
      },
      "EAEORECW" => {
        "temporal_operator" => "GREATEREQUAL",
        "join_column_left" => "ENDDATE",
        "join_column_right" => "ENDDATE"
      },
      "ECWS" => {
        "temporal_operator" => "EQUAL",
        "join_column_left" => "ENDDATE",
        "join_column_right" => "STARTDATE"
      },
      "ECW" => {
        "temporal_operator" => "EQUAL",
        "join_column_left" => "ENDDATE",
        "join_column_right" => "ENDDATE"
      },
      "SDU" => {
        "temporal_operator(start)" => "GREATER",
        "temporal_operator(end)" => "LESS",
        "join_column_left(start)" => "STARTDATE",
        "join_column_left(end)" => "STARTDATE"
      },
      "EDU" => {
        "temporal_operator(start)" => "GREATER",
        "temporal_operator(end)" => "LESS",
        "join_column_left(start)" => "ENDDATE",
        "join_column_left(end)" => "ENDDATE"
      },
      "CONCURRENT" => {
        "temporal_operator(start)" => "EQUAL",
        "temporal_operator(end)" => "EQUAL",
        "join_column_left(start)" => "STARTDATE",
        "join_column_left(end)" => "ENDDATE"
      },
      "OVERLAP" => {
        "temporal_operator(start)" => "GREATER",
        "temporal_operator(end)" => "LESS",
        "join_column_left(start)" => "STARTDATE",
        "join_column_left(end)" => "STARTDATE"
      },
      "DURING" => {
        "temporal_operator(start)" => "GREATER",
        "temporal_operator(end)" => "LESS",
        "join_column_left(start)" => "STARTDATE",
        "join_column_left(end)" => "ENDDATE"
      }

    }

  end
end

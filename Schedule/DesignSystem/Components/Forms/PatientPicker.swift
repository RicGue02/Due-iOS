//
//  PatientPicker.swift
//  Fisioflow - Design System Components
//  Patient Selection Component for Appointments
//
//  Created by Ricardo Guerrero Godínez on 15/7/25.
//

import SwiftUI

// MARK: - Patient Picker Component
struct PatientPicker: View {
    let title: String
    @Binding var selectedPatient: Patient?
    let patients: [Patient]
    let isRequired: Bool
    let errorMessage: String?
    let onPatientSelected: ((Patient) -> Void)?
    
    @State private var isShowingPicker = false
    @State private var searchText = ""
    
    init(
        title: String,
        selectedPatient: Binding<Patient?>,
        patients: [Patient],
        isRequired: Bool = false,
        errorMessage: String? = nil,
        onPatientSelected: ((Patient) -> Void)? = nil
    ) {
        self.title = title
        self._selectedPatient = selectedPatient
        self.patients = patients
        self.isRequired = isRequired
        self.errorMessage = errorMessage
        self.onPatientSelected = onPatientSelected
    }
    
    private var filteredPatients: [Patient] {
        if searchText.isEmpty {
            return patients.filter { !$0.isDeleted && !$0.isArchived }
        } else {
            return patients.filter { 
                !$0.isDeleted && 
                !$0.isArchived && 
                $0.matches(query: searchText) 
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Label
            HStack(spacing: Spacing.xs) {
                Text(title)
                    .textStyle(.formLabel)
                
                if isRequired {
                    Text("*")
                        .textStyle(.formLabel)
                        .foregroundColor(.error)
                }
            }
            
            // Patient Selection Button
            Button {
                isShowingPicker = true
                HapticFeedback.light()
            } label: {
                HStack {
                    if let patient = selectedPatient {
                        // Selected Patient Display
                        HStack(spacing: Spacing.md) {
                            // Patient Avatar
                            Circle()
                                .fill(Color.brandBlue.opacity(0.1))
                                .frame(width: Spacing.avatarSmall, height: Spacing.avatarSmall)
                                .overlay(
                                    Text(patient.initials)
                                        .font(.caption.weight(.semibold))
                                        .foregroundColor(.brandBlue)
                                )
                            
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text(patient.fullName)
                                    .font(.body)
                                    .foregroundColor(.labelPrimary)
                                
                                if let phone = patient.phone {
                                    Text(phone)
                                        .font(.caption)
                                        .foregroundColor(.labelSecondary)
                                }
                            }
                            
                            Spacer()
                        }
                    } else {
                        // Placeholder
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: Spacing.iconMedium))
                                .foregroundColor(.labelTertiary)
                            
                            Text("Seleccionar paciente")
                                .font(.body)
                                .foregroundColor(.placeholder)
                            
                            Spacer()
                        }
                    }
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: Spacing.iconSmall, weight: .medium))
                        .foregroundColor(.labelTertiary)
                }
                .padding(.horizontal, Spacing.md)
                .frame(height: 56) // Slightly taller for patient info
                .background(Color.fillTertiary)
                .cornerRadius(Spacing.radiusMedium)
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.radiusMedium)
                        .stroke(
                            errorMessage != nil ? Color.error : Color.clear,
                            lineWidth: 1.5
                        )
                )
                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Error Message
            if let errorMessage = errorMessage {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.error)
                    
                    Text(errorMessage)
                        .textStyle(.formError)
                }
            }
        }
        .sheet(isPresented: $isShowingPicker) {
            PatientPickerSheet(
                patients: patients,
                selectedPatient: $selectedPatient,
                searchText: $searchText,
                onPatientSelected: { patient in
                    selectedPatient = patient
                    onPatientSelected?(patient)
                    isShowingPicker = false
                    HapticFeedback.selection()
                }
            )
        }
    }
}

// MARK: - Patient Picker Sheet
private struct PatientPickerSheet: View {
    let patients: [Patient]
    @Binding var selectedPatient: Patient?
    @Binding var searchText: String
    let onPatientSelected: (Patient) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    private var filteredPatients: [Patient] {
        if searchText.isEmpty {
            return patients.filter { !$0.isDeleted && !$0.isArchived }
                .sorted { $0.lastName < $1.lastName }
        } else {
            return patients.filter { 
                !$0.isDeleted && 
                !$0.isArchived && 
                $0.matches(query: searchText) 
            }
            .sorted { patient1, patient2 in
                // Sort by relevance
                let query1Match = patient1.fullName.lowercased().hasPrefix(searchText.lowercased())
                let query2Match = patient2.fullName.lowercased().hasPrefix(searchText.lowercased())
                
                if query1Match && !query2Match {
                    return true
                } else if !query1Match && query2Match {
                    return false
                } else {
                    return patient1.lastName < patient2.lastName
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Field
                SearchField(
                    placeholder: "Buscar pacientes...", text: $searchText
                )
                .padding(.horizontal, Spacing.screenPadding)
                .padding(.vertical, Spacing.md)
                
                // Patient List
                if filteredPatients.isEmpty {
                    PatientPickerEmptyState(searchText: searchText)
                } else {
                    List {
                        ForEach(filteredPatients) { patient in
                            PatientPickerRow(
                                patient: patient,
                                isSelected: selectedPatient?.id == patient.id
                            ) {
                                onPatientSelected(patient)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                Spacer()
            }
            .navigationTitle("Seleccionar Paciente")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(.brandBlue)
                }
            }
        }
        .onAppear {
            // Clear search when sheet appears
            searchText = ""
        }
    }
}

// MARK: - Patient Picker Row
private struct PatientPickerRow: View {
    let patient: Patient
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                // Patient Avatar
                Circle()
                    .fill(Color.brandBlue.opacity(0.1))
                    .frame(width: Spacing.avatarMedium, height: Spacing.avatarMedium)
                    .overlay(
                        Text(patient.initials)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.brandBlue)
                    )
                
                // Patient Info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(patient.fullName)
                        .textStyle(.listTitle)
                    
                    HStack(spacing: Spacing.lg) {
                        if let phone = patient.phone {
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: "phone.fill")
                                    .font(.caption)
                                    .foregroundColor(.labelTertiary)
                                Text(phone)
                                    .textStyle(.listCaption)
                            }
                        }
                        
                        if let email = patient.email {
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: "envelope.fill")
                                    .font(.caption)
                                    .foregroundColor(.labelTertiary)
                                Text(email)
                                    .textStyle(.listCaption)
                            }
                        }
                    }
                    
                    if !patient.allergies.isEmpty {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundColor(.warning)
                            Text("Alergias: \(patient.allergies.joined(separator: ", "))")
                                .textStyle(.listCaption)
                                .foregroundColor(.warning)
                        }
                    }
                }
                
                Spacer()
                
                // Selection Indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: Spacing.iconMedium))
                        .foregroundColor(.brandBlue)
                }
            }
            .padding(.vertical, Spacing.sm)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Empty State
private struct PatientPickerEmptyState: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "person.3")
                .font(.system(size: 48))
                .foregroundColor(.labelTertiary)
            
            VStack(spacing: Spacing.sm) {
                Text(searchText.isEmpty ? "No hay pacientes" : "No se encontraron pacientes")
                    .textStyle(.sectionTitle)
                
                Text(searchText.isEmpty ? 
                     "Agrega pacientes primero para poder programar citas" :
                     "Intenta con otro término de búsqueda")
                    .textStyle(.listSubtitle)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview
struct PatientPicker_Previews: PreviewProvider {
    @State static var selectedPatient: Patient? = nil
    
    static var previews: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                PatientPicker(
                    title: "Paciente",
                    selectedPatient: $selectedPatient,
                    patients: Patient.samplePatients,
                    isRequired: true
                )
                
                PatientPicker(
                    title: "Paciente",
                    selectedPatient: .constant(Patient.samplePatients.first),
                    patients: Patient.samplePatients,
                    errorMessage: "Debe seleccionar un paciente"
                )
            }
            .screenPadding()
        }
        .background(Color.surfacePrimary)
    }
}


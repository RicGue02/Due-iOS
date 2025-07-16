//
//  OnboardingSteps.swift
//  Schedule
//
//  Created for Due Student App
//

import SwiftUI

// MARK: - Welcome Step
struct WelcomeStepView: View {
    var body: some View {
        VStack(spacing: 24) {
            // App icon or illustration
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
                .background {
                    Circle()
                        .fill(.blue.opacity(0.1))
                        .frame(width: 120, height: 120)
                }
            
            VStack(spacing: 16) {
                Text("📚 Organize your classes")
                Text("📝 Track assignments")
                Text("⏰ Never miss deadlines")
                Text("🎯 Boost your grades")
            }
            .font(.headline)
            .foregroundStyle(.primary)
        }
    }
}

// MARK: - Academic Level Step
struct AcademicLevelStepView: View {
    @Bindable var state: OnboardingState
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(AcademicLevel.allCases, id: \.self) { level in
                AcademicLevelCard(
                    level: level,
                    isSelected: state.selectedLevel == level
                ) {
                    state.selectedLevel = level
                    state.subjectCount = level.defaultSubjectCount
                }
            }
        }
    }
}

struct AcademicLevelCard: View {
    let level: AcademicLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: level.icon)
                    .font(.title)
                    .foregroundStyle(isSelected ? .white : .blue)
                
                Text(level.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isSelected ? .white : .primary)
                
                Text(level.description)
                    .font(.caption)
                    .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 120)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .blue : .black)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? .blue : .clear, lineWidth: 2)
                    }
            }
        }
        .buttonStyle(.plain)
        .animation(.smooth(duration: 0.2), value: isSelected)
    }
}

// MARK: - Template Step
struct TemplateStepView: View {
    @Bindable var state: OnboardingState
    
    var body: some View {
        VStack(spacing: 16) {
            if let selectedLevel = state.selectedLevel {
                let templates = AcademicTemplate.getTemplates(for: selectedLevel)
                
                ForEach(templates, id: \.id) { template in
                    TemplateCard(
                        template: template,
                        isSelected: state.selectedTemplate?.id == template.id
                    ) {
                        state.selectedTemplate = template
                        state.subjectCount = template.subjectCount
                    }
                }
            } else {
                Text("Please go back and select your academic level")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct TemplateCard: View {
    let template: AcademicTemplate
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(template.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(isSelected ? .white : .primary)
                    
                    Text("\(template.subjectCount) subjects typically")
                        .font(.subheadline)
                        .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                    
                    HStack {
                        ForEach(template.commonSubjects.prefix(3), id: \.self) { subject in
                            Text(subject)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background {
                                    Capsule()
                                        .fill(isSelected ? .white.opacity(0.2) : .blue.opacity(0.1))
                                }
                                .foregroundStyle(isSelected ? .white : .blue)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : .blue)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .blue : .red)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? .blue : .gray.opacity(0.3), lineWidth: 1)
                    }
            }
        }
        .buttonStyle(.plain)
        .animation(.smooth(duration: 0.2), value: isSelected)
    }
}

// MARK: - Subject Count Step
struct SubjectCountStepView: View {
    @Bindable var state: OnboardingState
    
    var body: some View {
        VStack(spacing: 32) {
            // Large number display
            Text("\(state.subjectCount)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundStyle(.blue)
                .contentTransition(.numericText())
                .animation(.smooth, value: state.subjectCount)
            
            // Stepper
            HStack(spacing: 20) {
                Button {
                    if state.subjectCount > 1 {
                        withAnimation(.smooth) {
                            state.subjectCount -= 1
                        }
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundStyle(state.subjectCount > 1 ? .blue : .gray)
                }
                .disabled(state.subjectCount <= 1)
                
                Text("subjects")
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(minWidth: 100)
                
                Button {
                    if state.subjectCount < 15 {
                        withAnimation(.smooth) {
                            state.subjectCount += 1
                        }
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundStyle(state.subjectCount < 15 ? .blue : .gray)
                }
                .disabled(state.subjectCount >= 15)
            }
            .buttonStyle(.plain)
            
            // Quick presets
            HStack(spacing: 12) {
                ForEach([3, 5, 7, 10], id: \.self) { count in
                    Button("\(count)") {
                        withAnimation(.smooth) {
                            state.subjectCount = count
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(state.subjectCount == count ? .blue : .gray)
                }
            }
            
            Text("Don't worry, you can adjust this anytime")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Quick Setup Step
struct QuickSetupStepView: View {
    @Bindable var state: OnboardingState
    @State private var showingAddSubject = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Optional: Student name and institution
            VStack(spacing: 16) {
                TextField("Your name (optional)", text: $state.studentName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Your school/university", text: $state.institution)
                    .textFieldStyle(.roundedBorder)
            }
            
            Divider()
            
            // Quick add first subject
            VStack(spacing: 16) {
                Text("Ready to add your first class?")
                    .font(.headline)
                
                Button {
                    showingAddSubject = true
                } label: {
                    Label("Add Your First Class", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                
                Text("Or skip this and add classes later")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .sheet(isPresented: $showingAddSubject) {
            AddScheduleView()
        }
    }
}

// MARK: - Completed Step
struct CompletedStepView: View {
    var body: some View {
        VStack(spacing: 24) {
            // Success animation
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)
                .background {
                    Circle()
                        .fill(.green.opacity(0.1))
                        .frame(width: 120, height: 120)
                }
            
            VStack(spacing: 16) {
                Text("🎉 You're ready to succeed!")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(spacing: 8) {
                    Text("✅ Your schedule is set up")
                    Text("✅ Notifications are ready")
                    Text("✅ Widget is configured")
                }
                .font(.body)
                .foregroundStyle(.secondary)
            }
            
            Text("Pro tip: Add Due's widget to your home screen for quick access to your schedule!")
                .font(.caption)
                .foregroundStyle(.blue)
                .multilineTextAlignment(.center)
                .padding()
                .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview("Welcome") {
    WelcomeStepView()
}

#Preview("Academic Level") {
    AcademicLevelStepView(state: OnboardingState())
}

#Preview("Template") {
    TemplateStepView(state: {
        let state = OnboardingState()
        state.selectedLevel = .university
        return state
    }())
}

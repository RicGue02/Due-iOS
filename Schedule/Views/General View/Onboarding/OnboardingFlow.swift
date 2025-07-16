//
//  OnboardingFlow.swift
//  Schedule
//
//  Created for Due Student App
//

import SwiftUI

struct OnboardingFlow: View {
    @State private var onboardingState = OnboardingState()
    @Environment(ScheduleModel.self) private var scheduleModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress bar
                    OnboardingProgressBar(progress: onboardingState.progress)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Content
                    TabView(selection: $onboardingState.currentStep) {
                        ForEach(OnboardingState.OnboardingStep.allCases, id: \.self) { step in
                            OnboardingStepView(step: step, state: onboardingState)
                                .tag(step)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.smooth, value: onboardingState.currentStep)
                    
                    // Navigation buttons
                    OnboardingNavigationButtons(state: onboardingState) {
                        completeOnboarding()
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func completeOnboarding() {
        // Apply selected template to schedule model
        if let template = onboardingState.selectedTemplate {
            applyTemplate(template)
        }
        
        // Mark onboarding as completed
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        onboardingState.isCompleted = true
        
        // Notify app of completion
        NotificationCenter.default.post(name: .onboardingCompleted, object: nil)
        
        dismiss()
    }
    
    private func applyTemplate(_ template: AcademicTemplate) {
        // Create sample subjects based on template
        let subjectsToCreate = Array(template.commonSubjects.prefix(onboardingState.subjectCount))
        
        for (index, subjectName) in subjectsToCreate.enumerated() {
            let schedule = Schedule(
                id: UUID().uuidString,
                name: subjectName,
                urls: "",
                imageURL: nil,
                description: onboardingState.institution.isEmpty ? "Universidad de Costa Rica" : onboardingState.institution,
                clase: "",
                recursos: "",
                chat: "",
                highlights: ["Professor TBD"],
                times: [], // Will be populated during quick setup
                moreinfo: ["Add more details later"]
            )
            
            scheduleModel.schedules.append(schedule)
        }
    }
}

// MARK: - Progress Bar
struct OnboardingProgressBar: View {
    let progress: Double
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Setup Progress")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .animation(.smooth(duration: 0.3), value: progress)
        }
    }
}

// MARK: - Step View
struct OnboardingStepView: View {
    let step: OnboardingState.OnboardingStep
    @Bindable var state: OnboardingState
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 20)
                
                // Header
                VStack(spacing: 12) {
                    Text(step.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(step.subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer(minLength: 20)
                
                // Step content
                Group {
                    switch step {
                    case .welcome:
                        WelcomeStepView()
                    case .academicLevel:
                        AcademicLevelStepView(state: state)
                    case .template:
                        TemplateStepView(state: state)
                    case .subjectCount:
                        SubjectCountStepView(state: state)
                    case .quickSetup:
                        QuickSetupStepView(state: state)
                    case .completed:
                        CompletedStepView()
                    }
                }
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Navigation Buttons
struct OnboardingNavigationButtons: View {
    @Bindable var state: OnboardingState
    let onComplete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Back button
            if state.currentStep != .welcome {
                Button("Back") {
                    withAnimation(.smooth) {
                        state.previousStep()
                    }
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            }
            
            // Next/Complete button
            Button(nextButtonTitle) {
                withAnimation(.smooth) {
                    if state.currentStep == .completed {
                        onComplete()
                    } else {
                        state.nextStep()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .disabled(!state.canProceed)
        }
    }
    
    private var nextButtonTitle: String {
        switch state.currentStep {
        case .welcome: return "Get Started"
        case .completed: return "Start Using Due"
        default: return "Continue"
        }
    }
}

#Preview {
    OnboardingFlow()
        .environment(ScheduleModel())
}
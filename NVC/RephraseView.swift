//
//  RephraseView.swift
//  NVC
//
//  Created by Jesse Shepard & ChatGPT on 6/5/23.
//

import SwiftUI
import Speech

struct Prompts {
    static let rephrase = """
    ORIGINAL TEXT: "%@"
    1: {Provide a rephrased version of the ORIGINAL TEXT,
    utilizing Marshall Rosenberg's techniques from his book Nonviolent Communication,
    utilizing all four steps of the NVC process
    (Sharing observations, Sharing feelings, Sharing needs, and Requesting Action)}
    2: {Provide a casual, informal rephrased version of the ORIGINAL TEXT,
    utilizing Marshall Rosenberg's techniques from his book Nonviolent Communication,
    utilizing all four steps of the NVC process
    (Sharing observations, Sharing feelings, Sharing needs, and Requesting Action)}
    3: {Provide an empathetic, positive rephrased version of the ORIGINAL TEXT,
    utilizing Marshall Rosenberg's techniques from his book Nonviolent Communication,
    utilizing all four steps of the NVC process
    (Sharing observations, Sharing feelings, Sharing needs, and Requesting Action)}
    4: {Provide a light-hearted rephrased version of the ORIGINAL TEXT,
    utilizing Marshall Rosenberg's techniques from his book Nonviolent Communication,
    utilizing all four steps of the NVC process
    (Sharing observations, Sharing feelings, Sharing needs, and Requesting Action)}
    5: {Analyze how the original text (not the rephrased text) meets,
    or fails to meet, NVC step #1 - If it fails, how could it meet it?}
    6: {Analyze how the original text (not the rephrased text) meets,
    or fails to meet, NVC step #2 - If it fails, how could it meet it?}
    7: {Analyze how the original text (not the rephrased text) meets,
    or fails to meet, NVC step #3 - If it fails, how could it meet it?}
    8: {Analyze how the original text (not the rephrased text) meets,
    or fails to meet, NVC step #4 - If it fails, how could it meet it?}
    """
    static let respond = """
    ORIGINAL TEXT: "%@"
    You are responding to the user's ORIGINAL TEXT in a roleplay scenario.
    You are demonstrating what an appropriate, nonviolent response could be.
    1: {Simulate a nonviolent response to the ORIGINAL TEXT,
    utilizing Marshall Rosenberg's techniques from his book Nonviolent Communication,
    utilizing all four steps of the NVC process
    (Sharing observations, Sharing feelings, Sharing needs, and Requesting Action)}
    2: {Simulate a casual, informal nonviolent response to the ORIGINAL TEXT,
    utilizing Marshall Rosenberg's techniques from his book Nonviolent Communication,
    utilizing all four steps of the NVC process
    (Sharing observations, Sharing feelings, Sharing needs, and Requesting Action)}
    3: {Simulate an empathetic, positive nonviolent response to the ORIGINAL TEXT,
    utilizing Marshall Rosenberg's techniques from his book Nonviolent Communication,
    utilizing all four steps of the NVC process
    (Sharing observations, Sharing feelings, Sharing needs, and Requesting Action)}
    4: {Simulate a light-hearted nonviolent response to the ORIGINAL TEXT,
    utilizing Marshall Rosenberg's techniques from his book Nonviolent Communication,
    utilizing all four steps of the NVC process
    (Sharing observations, Sharing feelings, Sharing needs, and Requesting Action)}
    5: {Analyze how the original text (not the response text) meets,
    or fails to meet, NVC step #1 - If it fails, how could it meet it?}
    6: {Analyze how the original text (not the response text) meets,
    or fails to meet, NVC step #2 - If it fails, how could it meet it?}
    7: {Analyze how the original text (not the response text) meets,
    or fails to meet, NVC step #3 - If it fails, how could it meet it?}
    8: {Analyze how the original text (not the response text) meets,
    or fails to meet, NVC step #4 - If it fails, how could it meet it?}
    """
}

struct RephraseView: View {
    @ObservedObject var viewModel = SpeechToText()
    @State private var selectedRephraseType = "Default"
    @EnvironmentObject var appState: AppState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let rephraseTypes = ["Default", "Informal", "Positive", "Light", "NVC Steps"]

    var body: some View {
        ZStack {
            Color(red: Double(38) / 255, green: Double(70) / 255, blue: Double(83) / 255)
                .edgesIgnoringSafeArea(.all)
            VStack {
                GeometryReader { _ in
                    VStack {
                        VStack {
                            buildContent()
                                .padding(.top)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        responseText()
                    }
                    .frame(maxWidth: .infinity)
                }
                Picker("Rephrase type", selection: $selectedRephraseType) {
                    ForEach(rephraseTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .accentColor(Color.red)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewModel.setAppState(appState)
            }
            if viewModel.isFetching == true {
                BubblePopView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    func buildContent() -> some View {
        if self.viewModel.isRecording {
            Text("Recording...")
                .font(.largeTitle)
                .foregroundColor((Color(red: Double(231) / 255, green: Double(111) / 255, blue: Double(81) / 255)))
        }
        VStack {
            HStack {
                TextField("Enter text to be rephrased into NVC", text: self.$viewModel.userText)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .accentColor(.primary)
                    .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                modeToggle()
                recordingButton()
                resetButton()
                analyzeButton()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    func responseText() -> some View {
        if viewModel.outputArray.count > 0 {
            ScrollView {
                VStack {
                    if selectedRephraseType == "Default" && viewModel.outputArray.indices.contains(0) {
                        Text(viewModel.outputArray[0])
                            .padding()
                            .foregroundColor(.black)
                            .font(.body)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    } else if selectedRephraseType == "Informal" && viewModel.outputArray.indices.contains(1) {
                        Text(viewModel.outputArray[1])
                            .padding()
                            .foregroundColor(.black)
                            .font(.body)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    } else if selectedRephraseType == "Positive" && viewModel.outputArray.indices.contains(2) {
                        Text(viewModel.outputArray[2])
                            .padding()
                            .foregroundColor(.black)
                            .font(.body)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    } else if selectedRephraseType == "Light" && viewModel.outputArray.indices.contains(3) {
                        Text(viewModel.outputArray[3])
                            .padding()
                            .foregroundColor(.black)
                            .font(.body)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    } else if selectedRephraseType == "NVC Steps" && viewModel.outputArray.indices.contains(4...7) {
                        ForEach(viewModel.outputArray[4...7], id: \.self) { text in
                            Text(text)
                                .padding()
                                .foregroundColor(.black)
                                .font(.body)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                        }
                    } else {
                        Text("The API didn't fully understand the instructions. Please try again.")
                            .padding()
                            .foregroundColor(.black)
                            .font(.body)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }

    @ViewBuilder
    func buildControls() -> some View {
        if self.viewModel.isRecording {
            Text("Recording...")
                .font(.largeTitle)
                .foregroundColor((Color(red: Double(231) / 255, green: Double(111) / 255, blue: Double(81) / 255)))
        }
        VStack {
            HStack {
                TextField("Enter text to be rephrased into NVC", text: self.$viewModel.userText)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                VStack {
                    HStack {
                        modeToggle()
                        recordingButton()
                        resetButton()
                        analyzeButton()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            buildButtons()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    func buildButtons() -> some View {
        GeometryReader { geometry in
            if geometry.size.width < 500 {
                buildButtonsForSmallWidth()
            } else {
                buildButtonsForLargeWidth()
            }
        }
    }

    func buildButtonsForSmallWidth() -> some View {
        VStack {
            HStack {
                Toggle(isOn: $viewModel.showDefault) {
                    Image(systemName: "Default")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Toggle(isOn: $viewModel.showInformal) {
                    Image(systemName: "bubble.right")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Toggle(isOn: $viewModel.showPositive) {
                    Text("Positive")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Toggle(isOn: $viewModel.showLight) {
                    Text("Light")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Toggle(isOn: $viewModel.showSteps) {
                    Text("NVC Steps")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity)
    }

    func buildButtonsForLargeWidth() -> some View {
        HStack {
            Toggle(isOn: $viewModel.showDefault) {
                Text("Default")
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Toggle(isOn: $viewModel.showInformal) {
                Text("Informal")
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Toggle(isOn: $viewModel.showPositive) {
                Text("Positive")
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Toggle(isOn: $viewModel.showLight) {
                Text("Light")
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Toggle(isOn: $viewModel.showSteps) {
                Text("NVC Steps")
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    func modeToggle() -> some View {
        let action = {
            appState.isRespondMode.toggle()
            print("isRespondMode after toggling is now:\(appState.isRespondMode)")
        }
        return Button(action: action) {
            Image(systemName: appState.isRespondMode ?
                  "bubble.left.and.bubble.right.fill" : "arrow.triangle.2.circlepath")
        }
        .padding()
        .foregroundColor(Color(.white))
        .background(Color(red: Double(156) / 255, green: Double(163) / 255, blue: Double(219) / 255))
        .cornerRadius(10)
    }

    func recordingButton() -> some View {
        let action = {
            if self.viewModel.isRecording {
                self.viewModel.stopRecording()
            } else {
                self.viewModel.startRecording()
            }
        }
        return Button(action: action) {
            Image(systemName: self.viewModel.isRecording ? "stop.fill" : "record.circle")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color(red: Double(231) / 255, green: Double(111) / 255, blue: Double(81) / 255))
        .cornerRadius(10)
    }

    func resetButton() -> some View {
        let action = {
            self.viewModel.resetRecording()
            viewModel.outputArray = []
        }
        return Button(action: action) {
            Image(systemName: "arrow.counterclockwise")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color(red: Double(233) / 255, green: Double(196) / 255, blue: Double(106) / 255))
        .cornerRadius(10)
    }

    func analyzeButton() -> some View {
        let action = {
            print("Analyze button pressed")
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            self.viewModel.callAPI(appState: appState)
            self.viewModel.stopRecording()
        }
        return Button(action: action) {
            if viewModel.isFetching {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
            } else {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color(red: Double(42) / 255, green: Double(157) / 255, blue: Double(143) / 255))
        .cornerRadius(10)
    }
}

class SpeechToText: ObservableObject {
    @Published var userText = ""
    @Published var output = ""
    @Published var backgroundColor: Color = .white
    @Published var chosenPrompt = ""
    @Published var isRecording = false
    @Published var isFetching = false
    @Published var showDefault = true
    @Published var showInformal = false
    @Published var showPositive = false
    @Published var showLight = false
    @Published var showSteps = false
    @Published var recordedText: String = ""
    @Published var recognitionTask: SFSpeechRecognitionTask?
    @Published var outputArray: [String] = []
    @Published private var recognitionRequestWrapper = RecognitionRequestWrapper()
    var appState: AppState?

    func setAppState(_ appState: AppState) {
        self.appState = appState
    }

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private let audioEngine = AVAudioEngine()

    func resetRecording() {
         if isRecording {
             stopRecording()
         }
         print("This is the prompt before reset \(self.userText)")
         self.userText = ""
         print("This is the prompt after reset \(self.userText)")
         self.recordedText = ""
        self.output = ""
     }

    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequestWrapper.request?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        DispatchQueue.main.async {
            self.isRecording = false
            print("This is the recorded text \(self.recordedText)")
            // Only update userText if recordedText is not empty
            if !self.recordedText.isEmpty {
                self.userText = self.recordedText
            }
            print("This is the prompt \(self.userText)")
        }
    }

    func startRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequestWrapper.request?.endAudio()
            isRecording = false
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { allowed in
                if allowed {
                    do {
                        try self.startSession()
                    } catch {
                        print("Failed to start session: \(error)")
                    }
                }
            }
        }
    }

    func startSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequestWrapper.request = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequestWrapper.request?.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequestWrapper.request!) { result, error in
            if let result = result {
                let transcript = result.bestTranscription.formattedString
                DispatchQueue.main.async {
                    self.recordedText = transcript
                    print("This is the prompt before setting in recognitionTask \(self.userText)")
                    self.userText = transcript  // Moved here
                    print("This is the prompt after setting in recognitionTask \(self.userText)")
                }
            }

            if error != nil {
                print("Error during recognition: \(String(describing: error))")
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequestWrapper.request = nil
                self.recognitionTask = nil
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(
            onBus: 0, bufferSize: 1024, format: recordingFormat) {(buffer: AVAudioPCMBuffer, _: AVAudioTime)
            in self.recognitionRequestWrapper.request?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        isRecording = true
    }

    func processAPIResult(_ result: Result<String, APIError>) {
        DispatchQueue.main.async {
            self.isFetching = false
            switch result {
            case .success(let response):
                let trimmedResponse = response.trimmingCharacters(in: .newlines)
                print("API response received: \(trimmedResponse)")
                self.outputArray = self.parseAPIResponse(trimmedResponse)
            case .failure(let error):
                print("API error received: \(error)")
                self.output = "Error: \(error.localizedDescription)"
            }
        }
    }

    func parseAPIResponse(_ response: String) -> [String] {
        var resultArray: [String] = []
        let lines = response.split(separator: "\n")
        for line in lines {
            let indexColon = line.firstIndex(of: ":")
            let indexPeriod = line.firstIndex(of: ".")
            if let index = indexColon ?? indexPeriod {
                let valueStartIndex = line.index(index, offsetBy: 2)
                let value = String(line[valueStartIndex...]).trimmingCharacters(in: .whitespaces)
                resultArray.append(value)
            }
        }
        return resultArray
    }

    func callAPI(appState: AppState) {
        print("Call API function started with prompt: \(userText)")
        self.isFetching = true

        let chosenPrompt = appState.isRespondMode ?
            String(format: Prompts.respond, userText) : String(format: Prompts.rephrase, userText)
        print("Prompt chosen:\(chosenPrompt)")

        getGPT3Response(prompt: chosenPrompt) { result in
            self.processAPIResult(result)
        }
    }
}

class RecognitionRequestWrapper: ObservableObject {
    @Published var request: SFSpeechAudioBufferRecognitionRequest?
}

class AppState: ObservableObject {
    @Published var isRespondMode: Bool = false
}

struct RephraseView_Previews: PreviewProvider {
    static var previews: some View {
        RephraseView()
            .previewDevice(PreviewDevice(rawValue: "iPad (10th generation)"))
            .previewDisplayName("iPad (10th generation)")
    }
}

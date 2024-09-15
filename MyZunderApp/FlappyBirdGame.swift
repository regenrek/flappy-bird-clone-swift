import SwiftUI

// MARK: - Models

struct Bird {
    var position: CGPoint
    var velocity: CGFloat = 0
    let size: CGSize = CGSize(width: 50, height: 50)
}

struct Pipe {
    var position: CGPoint
    let width: CGFloat = 80
    let gap: CGFloat = 200
    var height: CGFloat
}

// MARK: - Game State

class GameState: ObservableObject {
    @Published var bird: Bird
    @Published var pipes: [Pipe] = []
    @Published var score: Int = 0
    @Published var isGameOver = false
    
    let gravity: CGFloat = 0.8
    let jumpVelocity: CGFloat = -15
    
    init(screenSize: CGSize) {
        bird = Bird(position: CGPoint(x: screenSize.width / 3, y: screenSize.height / 2))
        addPipe(screenSize: screenSize)
    }
    
    func addPipe(screenSize: CGSize) {
        let pipeHeight = CGFloat.random(in: 100...screenSize.height - 300)
        let pipe = Pipe(position: CGPoint(x: screenSize.width, y: 0), height: pipeHeight)
        pipes.append(pipe)
    }
    
    func update(screenSize: CGSize) {
        if isGameOver { return }
        
        // Update bird position
        bird.velocity += gravity
        bird.position.y += bird.velocity
        
        // Update pipes
        for i in 0..<pipes.count {
            pipes[i].position.x -= 5
            
            // Check collision
            if checkCollision(bird: bird, pipe: pipes[i], screenSize: screenSize) {
                isGameOver = true
            }
            
            // Increase score
            if pipes[i].position.x == bird.position.x {
                score += 1
            }
        }
        
        // Remove off-screen pipes
        pipes = pipes.filter { $0.position.x > -$0.width }
        
        // Add new pipe
        if pipes.last?.position.x ?? 0 < screenSize.width - 300 {
            addPipe(screenSize: screenSize)
        }
        
        // Check if bird is out of bounds
        if bird.position.y > screenSize.height || bird.position.y < 0 {
            isGameOver = true
        }
    }
    
    func jump() {
        bird.velocity = jumpVelocity
    }
    
    func checkCollision(bird: Bird, pipe: Pipe, screenSize: CGSize) -> Bool {
        let birdRect = CGRect(x: bird.position.x, y: bird.position.y, width: bird.size.width, height: bird.size.height)
        let upperPipeRect = CGRect(x: pipe.position.x, y: 0, width: pipe.width, height: pipe.height)
        let lowerPipeRect = CGRect(x: pipe.position.x, y: pipe.height + pipe.gap, width: pipe.width, height: screenSize.height - pipe.height - pipe.gap)
        
        return birdRect.intersects(upperPipeRect) || birdRect.intersects(lowerPipeRect)
    }
    
    func restart(screenSize: CGSize) {
        bird = Bird(position: CGPoint(x: screenSize.width / 3, y: screenSize.height / 2))
        pipes = []
        addPipe(screenSize: screenSize)
        score = 0
        isGameOver = false
    }
}

// MARK: - Views

struct ContentView: View {
    @StateObject private var gameState: GameState
    @State private var timer: Timer?
    
    init() {
        _gameState = StateObject(wrappedValue: GameState(screenSize: UIScreen.main.bounds.size))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.blue.opacity(0.3).edgesIgnoringSafeArea(.all)
                
                // Bird
                Circle()
                    .fill(Color.yellow)
                    .frame(width: gameState.bird.size.width, height: gameState.bird.size.height)
                    .position(gameState.bird.position)
                
                // Pipes
                ForEach(gameState.pipes.indices, id: \.self) { index in
                    PipeView(pipe: gameState.pipes[index])
                }
                
                // Score
                Text("Score: \(gameState.score)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .position(x: geometry.size.width / 2, y: 50)
                
                // Game Over
                if gameState.isGameOver {
                    VStack {
                        Text("Game Over")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Button("Restart") {
                            gameState.restart(screenSize: geometry.size)
                            startGame()
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        gameState.jump()
                    }
            )
            .onAppear {
                startGame()
            }
        }
    }
    
    func startGame() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            gameState.update(screenSize: UIScreen.main.bounds.size)
        }
    }
}

struct PipeView: View {
    let pipe: Pipe
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                // Upper pipe
                path.addRect(CGRect(x: pipe.position.x, y: 0, width: pipe.width, height: pipe.height))
                
                // Lower pipe
                path.addRect(CGRect(x: pipe.position.x, y: pipe.height + pipe.gap, width: pipe.width, height: geometry.size.height - pipe.height - pipe.gap))
            }
            .fill(Color.green)
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
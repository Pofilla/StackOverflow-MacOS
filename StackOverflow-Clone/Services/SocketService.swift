import Foundation
import Network

class Connection {
    let nwConnection: NWConnection
    let id: Int
    private static var nextID: Int = 0
    var didStopCallback: ((Error?) -> Void)? = nil
    
    init(nwConnection: NWConnection) {
        self.nwConnection = nwConnection
        self.id = Connection.nextID
        Connection.nextID += 1
    }
    
    func start() {
        print("Connection \(self.id) will start")
        self.nwConnection.stateUpdateHandler = self.stateDidChange(to:)
        self.setupReceive()
        self.nwConnection.start(queue: .main)
    }
    
    private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .setup:
            break
        case .waiting(let error):
            connectionDidFail(error: error)
        case .preparing:
            break
        case .ready:
            print("Connection \(self.id) ready")
        case .failed(let error):
            connectionDidFail(error: error)
        case .cancelled:
            break
        default:
            break
        }
    }
    
    private func setupReceive() {
        nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] (data, _, isComplete, error) in
            guard let self = self else { return }
            
            if let data = data, !data.isEmpty {
                print("Connection \(self.id) did receive, data: \(String(data: data, encoding: .utf8) ?? "")")
                NotificationCenter.default.post(name: .didReceiveData, object: data)
            }
            if isComplete {
                self.connectionDidEnd()
            } else if let error = error {
                self.connectionDidFail(error: error)
            } else {
                self.setupReceive()
            }
        }
    }
    
    func send(data: Data) {
        self.nwConnection.send(content: data, completion: .contentProcessed { [weak self] error in
            if let error = error {
                self?.connectionDidFail(error: error)
                return
            }
            print("Connection \(self?.id ?? 0) did send data")
        })
    }
    
    func stop() {
        print("Connection \(self.id) will stop")
        stop(error: nil)
    }
    
    private func connectionDidFail(error: Error) {
        print("Connection \(self.id) did fail, error: \(error)")
        self.stop(error: error)
    }
    
    private func connectionDidEnd() {
        print("Connection \(self.id) did end")
        self.stop(error: nil)
    }
    
    private func stop(error: Error?) {
        self.nwConnection.stateUpdateHandler = nil
        self.nwConnection.cancel()
        if let didStopCallback = self.didStopCallback {
            self.didStopCallback = nil
            didStopCallback(error)
        }
    }
}

class SocketService: ObservableObject {
    private var connection: Connection?
    @Published var isConnected = false
    private var responseHandlers: [(Data) -> Void] = []
    
    init() {
        setupConnection()
        setupNotifications()
    }
    
    private func setupConnection() {
        let connection = Connection(nwConnection: NWConnection(
            host: "127.0.0.1",
            port: 54321,
            using: .tcp
        ))
        
        connection.didStopCallback = { [weak self] error in
            print("Socket did stop with error: \(String(describing: error))")
            self?.isConnected = false
            // Attempt to reconnect after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.setupConnection()
            }
        }
        
        self.connection = connection
        connection.start()
        self.isConnected = true
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleReceivedData(_:)),
            name: .didReceiveData,
            object: nil
        )
    }
    
    @objc private func handleReceivedData(_ notification: Notification) {
        guard let data = notification.object as? Data else { return }
        // Execute and remove the first response handler
        if let handler = responseHandlers.first {
            responseHandlers.removeFirst()
            handler(data)
        }
    }
    
    func send<T: Encodable>(_ request: T, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let connection = connection else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No connection available"])))
            return
        }
        
        do {
            let data = try JSONEncoder.shared.encode(request)
            print("Sending: \(String(data: data, encoding: .utf8) ?? "")")
            
            // Add response handler before sending
            responseHandlers.append { responseData in
                completion(.success(responseData))
            }
            
            connection.send(data: data)
        } catch {
            completion(.failure(error))
        }
    }
    
    deinit {
        connection?.stop()
    }
}

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
} 

import socket
import json
import threading
from datetime import datetime, timezone
import pickle

class StackOverflowServer:
    def __init__(self):
        self.questions = self.load_questions()  # Load saved questions
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.host = '127.0.0.1'
        self.port = 54321

    def load_questions(self):
        try:
            with open('questions.pkl', 'rb') as f:
                return pickle.load(f)
        except:
            return []

    def save_questions(self):
        with open('questions.pkl', 'wb') as f:
            pickle.dump(self.questions, f)

    def start(self):
        try:
            print(f"\nBinding to {self.host}:{self.port}...")
            self.server_socket.bind((self.host, self.port))
            self.server_socket.listen(1)
            print("Server is listening!")

            while True:
                print("\nWaiting for new connection...")
                client_socket, address = self.server_socket.accept()
                print(f"New connection from {address}")
                
                client_thread = threading.Thread(
                    target=self.handle_client,
                    args=(client_socket, address)
                )
                client_thread.start()

        except Exception as e:
            print(f"Server error: {e}")
        finally:
            self.server_socket.close()

    def handle_client(self, client_socket, address):
        print(f"\nHandling client {address}")
        try:
            while True:
                data = client_socket.recv(4096)
                if not data:
                    print(f"Client {address} disconnected")
                    break
                
                print(f"Received from {address}: {data}")
                try:
                    request = json.loads(data.decode('utf-8'))
                    response = self.process_request(request)
                    response_data = json.dumps(response).encode('utf-8')
                    print(f"Sending to {address}: {response_data}")
                    client_socket.send(response_data)
                except json.JSONDecodeError as e:
                    print(f"JSON decode error: {e}")
                    break
        except Exception as e:
            print(f"Error handling request: {e}")
        finally:
            print(f"Closing connection with {address}")
            client_socket.close()

    def process_request(self, request):
        action = request.get('action')
        print(f"\nReceived request with action: {action}")
        print(f"Full request: {request}")
        
        try:
            if action == 'get_questions':
                print(f"Returning {len(self.questions)} questions")
                return {
                    'status': 'success',
                    'data': self.questions
                }
            
            elif action == 'add_question':
                question = request.get('question')
                print(f"Adding question: {question}")
                question['created_date'] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
                self.questions.insert(0, question)
                self.save_questions()
                print(f"Questions after adding: {len(self.questions)}")
                return {
                    'status': 'success',
                    'data': self.questions
                }
            
            elif action == 'add_answer':
                question_id = request.get('questionId')
                answer = request.get('answer')
                answer['created_date'] = datetime.now(timezone.utc).isoformat()
                
                for q in self.questions:
                    if q['id'] == question_id:
                        if 'answers' not in q:
                            q['answers'] = []
                        q['answers'].append(answer)
                        self.save_questions()  # Save after adding answer
                        break
                
                return {'status': 'success', 'data': self.questions}

            elif action == 'delete_answer':
                answer_id = request.get('answer_id')
                question_id = request.get('question_id')
                
                print(f"Deleting answer {answer_id} from question {question_id}")
                for question in self.questions:
                    if question['id'] == question_id:
                        question['answers'] = [a for a in question['answers'] if a['id'] != answer_id]
                        break
                
                self.save_questions()
                return {
                    'status': 'success',
                    'data': self.questions,
                    'message': 'Answer deleted successfully'
                }
            
            elif action == 'vote':
                question_id = request.get('questionId')
                vote_type = request.get('voteType')
                
                for q in self.questions:
                    if q['id'] == question_id:
                        if vote_type == 'upvote':
                            q['upvotes'] = q.get('upvotes', 0) + 1
                        elif vote_type == 'downvote':
                            q['downvotes'] = q.get('downvotes', 0) + 1
                        q['votes'] = q.get('upvotes', 0) - q.get('downvotes', 0)
                        break
                
                return {'status': 'success'}
            
            else:
                return {
                    'status': 'error',
                    'message': f'Unknown action: {action}'
                }
                
        except Exception as e:
            print(f"Error processing request: {e}")
            import traceback
            traceback.print_exc()
            return {
                'status': 'error',
                'message': str(e)
            }

if __name__ == '__main__':
    try:
        server = StackOverflowServer()
        server.start()
    except KeyboardInterrupt:
        print("\nServer shutting down...")
    except Exception as e:
        print(f"Fatal error: {e}") 
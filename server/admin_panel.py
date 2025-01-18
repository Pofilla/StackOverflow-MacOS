import tkinter as tk
from tkinter import ttk, messagebox
import pickle
import json
from datetime import datetime

class AdminPanel:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Stack Overflow Clone Admin Panel")
        self.root.geometry("1200x800")
        
        # Load data
        self.load_data()
        
        # Create main notebook (tabs)
        self.notebook = ttk.Notebook(self.root)
        self.notebook.pack(expand=True, fill='both', padx=10, pady=5)
        
        # Create tabs
        self.users_tab = ttk.Frame(self.notebook)
        self.questions_tab = ttk.Frame(self.notebook)
        
        self.notebook.add(self.users_tab, text='Users')
        self.notebook.add(self.questions_tab, text='Questions')
        
        # Initialize tabs
        self.init_users_tab()
        self.init_questions_tab()
        
        # Add refresh button
        refresh_btn = ttk.Button(self.root, text="Refresh Data", command=self.refresh_data)
        refresh_btn.pack(pady=5)

    def load_data(self):
        try:
            with open('server/database.pkl', 'rb') as f:
                self.data = pickle.load(f)
                self.users = self.data.get('users', {})
                self.questions = self.data.get('questions', [])
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load database: {str(e)}")
            self.data = {'users': {}, 'questions': []}
            self.users = {}
            self.questions = []

    def init_users_tab(self):
        # Create Treeview for users
        columns = ('Username', 'Email', 'Created Date')
        self.users_tree = ttk.Treeview(self.users_tab, columns=columns, show='headings')
        
        # Set column headings
        for col in columns:
            self.users_tree.heading(col, text=col)
            self.users_tree.column(col, width=200)
        
        # Add scrollbar
        scrollbar = ttk.Scrollbar(self.users_tab, orient='vertical', command=self.users_tree.yview)
        self.users_tree.configure(yscrollcommand=scrollbar.set)
        
        # Pack elements
        self.users_tree.pack(side='left', fill='both', expand=True)
        scrollbar.pack(side='right', fill='y')
        
        # Populate users
        self.populate_users()

    def init_questions_tab(self):
        # Create Treeview for questions
        columns = ('Title', 'Author', 'Created Date', 'Answers', 'Tags')
        self.questions_tree = ttk.Treeview(self.questions_tab, columns=columns, show='headings')
        
        # Set column headings
        for col in columns:
            self.questions_tree.heading(col, text=col)
            self.questions_tree.column(col, width=200)
        
        # Add scrollbar
        scrollbar = ttk.Scrollbar(self.questions_tab, orient='vertical', command=self.questions_tree.yview)
        self.questions_tree.configure(yscrollcommand=scrollbar.set)
        
        # Pack elements
        self.questions_tree.pack(side='left', fill='both', expand=True)
        scrollbar.pack(side='right', fill='y')
        
        # Populate questions
        self.populate_questions()

    def populate_users(self):
        # Clear existing items
        for item in self.users_tree.get_children():
            self.users_tree.delete(item)
        
        # Add users to treeview
        for email, user in self.users.items():
            created_date = user.get('created_date', 'N/A')
            self.users_tree.insert('', 'end', values=(
                user.get('username', 'N/A'),
                email,
                created_date
            ))

    def populate_questions(self):
        # Clear existing items
        for item in self.questions_tree.get_children():
            self.questions_tree.delete(item)
        
        # Add questions to treeview
        for question in self.questions:
            self.questions_tree.insert('', 'end', values=(
                question.get('title', 'N/A'),
                question.get('authorId', 'N/A'),
                question.get('created_date', 'N/A'),
                len(question.get('answers', [])),
                ', '.join(question.get('tags', []))
            ))

    def refresh_data(self):
        self.load_data()
        self.populate_users()
        self.populate_questions()
        messagebox.showinfo("Success", "Data refreshed successfully!")

    def run(self):
        # Add window close handler
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)
        # Start the application
        self.root.mainloop()

    def on_closing(self):
        if messagebox.askokcancel("Quit", "Do you want to quit?"):
            self.root.destroy()

if __name__ == "__main__":
    admin_panel = AdminPanel()
    admin_panel.run()

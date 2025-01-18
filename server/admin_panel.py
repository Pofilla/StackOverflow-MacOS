import customtkinter as ctk
from tkinter import ttk, messagebox
import pickle
from datetime import datetime
import json

# Set theme and color scheme
ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("blue")


class AdminPanel:
    def __init__(self):
        self.root = ctk.CTk()
        self.root.title("Stack Overflow Admin Panel")
        self.root.geometry("1400x800")

        # Configure style for treeview
        self.style = ttk.Style()
        self.style.theme_use('default')
        self.style.configure(
            "Treeview",
            background="#2b2b2b",
            foreground="white",
            fieldbackground="#2b2b2b",
        )
        self.style.configure("Treeview.Heading", background="#2b2b2b", foreground="white")

        # Load data
        self.load_data()

        # Create main layout
        self.create_layout()

    def create_layout(self):
        # Create sidebar
        self.sidebar = ctk.CTkFrame(self.root, width=200, corner_radius=0)
        self.sidebar.pack(side="left", fill="y", padx=0, pady=0)
        self.sidebar.pack_propagate(False)

        # App title in sidebar
        ctk.CTkLabel(
            self.sidebar,
            text="Admin Panel",
            font=ctk.CTkFont(size=20, weight="bold"),
        ).pack(pady=20, padx=10)

        # Navigation buttons
        self.create_nav_buttons()

        # Stats in sidebar
        self.create_stats_section()

        # Main content area
        self.main_content = ctk.CTkFrame(self.root)
        self.main_content.pack(side="right", fill="both", expand=True, padx=10, pady=10)

        # Initialize with users view
        self.show_users()

        # Refresh button at bottom of sidebar
        ctk.CTkButton(
            self.sidebar,
            text="Refresh Data",
            command=self.refresh_data,
            font=ctk.CTkFont(size=14),
        ).pack(side="bottom", pady=20, padx=20)

    def create_nav_buttons(self):
        buttons_frame = ctk.CTkFrame(self.sidebar, fg_color="transparent")
        buttons_frame.pack(fill="x", pady=10)

        self.nav_buttons = []

        users_btn = ctk.CTkButton(
            buttons_frame,
            text="Users",
            command=self.show_users,
            font=ctk.CTkFont(size=14),
        )
        users_btn.pack(pady=5, padx=20)
        self.nav_buttons.append(users_btn)

        questions_btn = ctk.CTkButton(
            buttons_frame,
            text="Questions",
            command=self.show_questions,
            font=ctk.CTkFont(size=14),
        )
        questions_btn.pack(pady=5, padx=20)
        self.nav_buttons.append(questions_btn)

    def create_stats_section(self):
        stats_frame = ctk.CTkFrame(self.sidebar)
        stats_frame.pack(fill="x", pady=20, padx=20)

        ctk.CTkLabel(
            stats_frame,
            text="Statistics",
            font=ctk.CTkFont(size=16, weight="bold"),
        ).pack(pady=10)

        # Users count
        self.users_count_label = ctk.CTkLabel(
            stats_frame,
            text=f"Total Users: {len(self.users)}",
            font=ctk.CTkFont(size=14),
        )
        self.users_count_label.pack(pady=5)

        # Questions count
        self.questions_count_label = ctk.CTkLabel(
            stats_frame,
            text=f"Total Questions: {len(self.questions)}",
            font=ctk.CTkFont(size=14),
        )
        self.questions_count_label.pack(pady=5)

    def create_table(self, parent, columns):
        # Create a frame for the table using tkinter Frame instead of CTkFrame
        table_frame = ttk.Frame(parent)
        table_frame.pack(fill="both", expand=True, padx=10, pady=10)

        # Create Treeview
        tree = ttk.Treeview(table_frame, columns=columns, show="headings", style="Treeview")

        # Configure columns
        for col in columns:
            tree.heading(col, text=col)
            tree.column(col, width=200)

        # Add scrollbars
        y_scrollbar = ttk.Scrollbar(table_frame, orient="vertical", command=tree.yview)
        y_scrollbar.pack(side="right", fill="y")

        x_scrollbar = ttk.Scrollbar(table_frame, orient="horizontal", command=tree.xview)
        x_scrollbar.pack(side="bottom", fill="x")

        tree.configure(yscrollcommand=y_scrollbar.set, xscrollcommand=x_scrollbar.set)
        tree.pack(fill="both", expand=True)

        return tree

    def show_users(self):
        # Clear main content
        for widget in self.main_content.winfo_children():
            widget.destroy()

        # Header
        header_frame = ctk.CTkFrame(self.main_content, fg_color="transparent")
        header_frame.pack(fill="x", pady=10)

        ctk.CTkLabel(
            header_frame,
            text="Users Management",
            font=ctk.CTkFont(size=20, weight="bold"),
        ).pack(side="left", padx=10)

        # Create users table
        columns = ("Username", "Email", "Created Date", "Actions")
        self.users_tree = self.create_table(self.main_content, columns)
        self.populate_users()

    def show_questions(self):
        # Clear main content
        for widget in self.main_content.winfo_children():
            widget.destroy()

        # Header
        header_frame = ctk.CTkFrame(self.main_content, fg_color="transparent")
        header_frame.pack(fill="x", pady=10)

        ctk.CTkLabel(
            header_frame,
            text="Questions Management",
            font=ctk.CTkFont(size=20, weight="bold"),
        ).pack(side="left", padx=10)

        # Create questions table
        columns = ("Title", "Author", "Created Date", "Answers", "Tags")
        self.questions_tree = self.create_table(self.main_content, columns)
        self.populate_questions()

    def load_data(self):
        try:
            with open("server/database.pkl", "rb") as f:
                self.data = pickle.load(f)
                self.users = self.data.get("users", {})
                self.questions = self.data.get("questions", [])
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load database: {str(e)}")
            self.data = {"users": {}, "questions": []}
            self.users = {}
            self.questions = []

    def populate_users(self):
        if not hasattr(self, "users_tree") or self.users_tree is None:
            messagebox.showerror("Error", "Users view is not initialized.")
            return

        # Clear existing items
        for item in self.users_tree.get_children():
            self.users_tree.delete(item)

        # Add users to treeview
        for email, user in self.users.items():
            created_date = user.get("created_date", "N/A")
            self.users_tree.insert(
                "",
                "end",
                values=(
                    user.get("username", "N/A"),
                    email,
                    created_date,
                    "🗑️",  # Delete action
                ),
            )

    def populate_questions(self):
        if not hasattr(self, "questions_tree") or self.questions_tree is None:
            messagebox.showerror("Error", "Questions view is not initialized.")
            return

        # Clear existing items
        for item in self.questions_tree.get_children():
            self.questions_tree.delete(item)

        # Add questions to treeview
        for question in self.questions:
            self.questions_tree.insert(
                "",
                "end",
                values=(
                    question.get("title", "N/A"),
                    question.get("authorId", "N/A"),
                    question.get("created_date", "N/A"),
                    len(question.get("answers", [])),
                    ", ".join(question.get("tags", [])),
                ),
            )

    def refresh_data(self):
        self.load_data()
        if hasattr(self, "users_tree") and self.users_tree:
            self.populate_users()
        if hasattr(self, "questions_tree") and self.questions_tree:
            self.populate_questions()

        # Update statistics
        self.users_count_label.configure(text=f"Total Users: {len(self.users)}")
        self.questions_count_label.configure(text=f"Total Questions: {len(self.questions)}")

        # Show success message
        messagebox.showinfo("Success", "Data refreshed successfully!")

    def run(self):
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)
        self.root.mainloop()

    def on_closing(self):
        if messagebox.askokcancel("Quit", "Do you want to quit?"):
            self.root.destroy()


if __name__ == "__main__":
    admin_panel = AdminPanel()
    admin_panel.run()

import 'package:flutter/material.dart';

void main() {
  runApp(const LoginRegisterApp());
}

class LoginRegisterApp extends StatelessWidget {
  const LoginRegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab Activity 3',
      // Requirement 1: Changed theme color (Teal / Cyan seed)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLogin = true;
  bool _hidePassword = true;
  bool _isLoggedIn = false;

  String? _registeredName;
  String? _registeredEmail;
  String? _registeredPassword;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _switchForm() {
    _formKey.currentState?.reset();
    _clearFields();
    setState(() {
      _isLogin = !_isLogin;
      _hidePassword = true;
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (_isLogin) {
      if (_registeredEmail == null) {
        _showMessage('Please register an account first.');
        return;
      }
      if (email != _registeredEmail || password != _registeredPassword) {
        _showMessage('Incorrect email or password.');
        return;
      }
      _clearFields();
      setState(() {
        _isLoggedIn = true;
      });
    } else {
      if (_registeredEmail != null) {
        _showMessage(
          'An account already exists. Please log in.',
        );
        return;
      }
      _registeredName = _nameController.text.trim();
      _registeredEmail = email;
      _registeredPassword = password;
      _formKey.currentState!.reset();
      _clearFields();
      setState(() {
        _isLogin = true;
        _hidePassword = true;
      });
      _showMessage('Registration successful! Please log in.');
    }
  }

  void _logout() {
    _clearFields();
    setState(() {
      _isLoggedIn = false;
      _isLogin = true;
      _hidePassword = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.teal,
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome, $_registeredName!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _registeredEmail ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLogin ? 'Login' : 'Register',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Requirement 2: Application Name above the form
                const Text(
                  'Alegria Portal App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 12),
                const Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.teal,
                ),
                const SizedBox(height: 16),
                Text(
                  _isLogin ? 'Welcome Back!' : 'Create an Account',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Display the name field during registration.
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) {
                      return 'Please enter your email.';
                    }
                    // Basic format check for this activity.
                    final emailPattern =
                        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailPattern.hasMatch(email)) {
                      return 'Please enter a valid email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      tooltip:
                          _hidePassword ? 'Show password' : 'Hide password',
                      icon: Icon(
                        _hidePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    // Requirement 4: Minimum 8 characters
                    if (value.length < 8) {
                      return 'Use at least 8 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Display confirmation during registration.
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _hidePassword,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password.';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    _isLogin ? 'Login' : 'Register',
                  ),
                ),
                const SizedBox(height: 8),

                TextButton(
                  onPressed: _switchForm,
                  child: Text(
                    _isLogin
                        ? 'No account yet? Register'
                        : 'Already have an account? Login',
                  ),
                ),

                const SizedBox(height: 24),

                // Requirement 3: Student Name and Section below the form
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        'Student Name: Juan Dela Cruz',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Section: BSIT 3-A',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

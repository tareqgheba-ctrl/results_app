import 'package:flutter/material.dart';

// ================= ================= =================
// 1. نماذج وهيكلية البيانات (Models & Data)
// ================= ================= =================

enum GradeLevel { baccalaureate, ninth }

class SubjectInfo {
  final String name;
  final double maxGrade;
  final double minGrade;

  SubjectInfo({
    required this.name,
    required this.maxGrade,
    required this.minGrade,
  });
}

class Student {
  final String id;
  final String name;
  final GradeLevel level;
  final Map<String, double> grades; // اسم المادة: العلامة

  Student({
    required this.id,
    required this.name,
    required this.level,
    required this.grades,
  });

  // قائمة المواد والحدود الدنيا والعظمى حسب الصف (النظام السوري)
  static List<SubjectInfo> getSubjectsForLevel(GradeLevel level) {
    if (level == GradeLevel.baccalaureate) {
      return [
        SubjectInfo(name: 'اللغة العربية', maxGrade: 400, minGrade: 160),
        SubjectInfo(name: 'الرياضيات', maxGrade: 600, minGrade: 240),
        SubjectInfo(name: 'الفيزياء', maxGrade: 400, minGrade: 160),
        SubjectInfo(name: 'الكيمياء', maxGrade: 200, minGrade: 80),
        SubjectInfo(name: 'علم الأحياء', maxGrade: 300, minGrade: 120),
        SubjectInfo(name: 'اللغة الإنكليزية', maxGrade: 300, minGrade: 120),
        SubjectInfo(name: 'اللغة الفرنسية', maxGrade: 400, minGrade: 160),
        SubjectInfo(name: 'التربية الدينية', maxGrade: 200, minGrade: 80),
      ];
    } else {
      return [
        SubjectInfo(name: 'اللغة العربية', maxGrade: 600, minGrade: 300),
        SubjectInfo(name: 'الرياضيات', maxGrade: 600, minGrade: 280),
        SubjectInfo(name: 'العلوم العامة', maxGrade: 400, minGrade: 160),
        SubjectInfo(name: 'الاجتماعيات', maxGrade: 600, minGrade: 240),
        SubjectInfo(name: 'اللغة الإنكليزية', maxGrade: 400, minGrade: 160),
        SubjectInfo(name: 'اللغة الفرنسية', maxGrade: 400, minGrade: 160),
        SubjectInfo(name: 'التربية الدينية', maxGrade: 200, minGrade: 80),
      ];
    }
  }

  // المجموع الكلي للطالب
  double get totalScore =>
      grades.values.fold(0, (sum, grade) => sum + grade);

  // المجموع الأعظمي الكلي للصف
  double get maxTotalScore => getSubjectsForLevel(level)
      .fold(0, (sum, sub) => sum + sub.maxGrade);

  // هل الطالب ناجح في جميع المواد؟
  bool get isPassed {
    final subjects = getSubjectsForLevel(level);
    for (var sub in subjects) {
      double studentGrade = grades[sub.name] ?? 0;
      if (studentGrade < sub.minGrade) {
        return false;
      }
    }
    return true;
  }
}

// قائمة بيانات الطلاب العامة المشتركة بين الشاشات
List<Student> globalStudentsList = [
  Student(
    id: '1001',
    name: 'أحمد طارق غيبة',
    level: GradeLevel.baccalaureate,
    grades: {
      'اللغة العربية': 380,
      'الرياضيات': 590,
      'الفيزياء': 380,
      'الكيمياء': 195,
      'علم الأحياء': 290,
      'اللغة الإنكليزية': 285,
      'اللغة الفرنسية': 370,
      'التربية الدينية': 190,
    },
  ),
  Student(
    id: '2001',
    name: 'محمود سامر',
    level: GradeLevel.ninth,
    grades: {
      'اللغة العربية': 550,
      'الرياضيات': 250, // أقل من الحد الأدنى -> راسب
      'العلوم العامة': 350,
      'الاجتماعيات': 500,
      'اللغة الإنكليزية': 320,
      'اللغة الفرنسية': 310,
      'التربية الدينية': 180,
    },
  ),
];

// ================= ================= =================
// 2. نقطة بداية التطبيق
// ================= ================= =================

void main() {
  runApp(const StudentResultsApp());
}

class StudentResultsApp extends StatelessWidget {
  const StudentResultsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نظام نتائج الطلاب التعليمي',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: WelcomeScreen(),
      ),
    );
  }
}

// ================= ================= =================
// 3. صفحة الترحيب وعن العلم
// ================= ================= =================

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بوابة النتائج التعليمية'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, size: 90, color: Colors.indigo),
                const SizedBox(height: 20),
                const Text(
                  '«رَبِّ زِدْنِي عِلْماً»',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'الع العلم نور يضيء عقول الأجيال، وبالمعرفة تُبنى الأمم وتسمو الشعوب.\nنضع بين أيديكم هذا النظام المتطور للاستعلام عن النتائج الامتحانية لمرحلتي التعليم الأساسي (التاسع) والتعليم الثانوي (البكالوريا) بكل دقة وسهولة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                ),
                const SizedBox(height: 40),
                // زر بوابة الطالب
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: StudentPortalScreen(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_search),
                  label: const Text('بوابة نتائج الطالب', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // زر بوابة المدير (مقفلة بكلمة سر)
                OutlinedButton.icon(
                  onPressed: () => _showAdminLoginDialog(context),
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('بوابة المدير (إدارة النتائج)', style: TextStyle(fontSize: 18)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.indigo),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // نافذة إدخال كلمة سر المدير
  void _showAdminLoginDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تسجيل دخول المدير'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'أدخل كلمة المرور',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                // كلمة المرور الافتراضية للمدير هي: 1234
                if (passwordController.text == '1234') {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Directionality(
                        textDirection: TextDirection.rtl,
                        child: AdminDashboardScreen(),
                      ),
                    ),
                  );
                } else {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('كلمة المرور غير صحيحة!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('دخول'),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ================= =================
// 4. بوابة الطالب (البحث برقم الاكتتاب فقط)
// ================= ================= =================

class StudentPortalScreen extends StatefulWidget {
  const StudentPortalScreen({super.key});

  @override
  State<StudentPortalScreen> createState() => _StudentPortalScreenState();
}

class _StudentPortalScreenState extends State<StudentPortalScreen> {
  final TextEditingController _idController = TextEditingController();
  Student? _foundStudent;
  bool _searched = false;

  void _searchStudent() {
    String query = _idController.text.trim();
    if (query.isEmpty) return;

    try {
      Student student = globalStudentsList.firstWhere((s) => s.id == query);
      setState(() {
        _foundStudent = student;
        _searched = true;
      });
    } catch (e) {
      setState(() {
        _foundStudent = null;
        _searched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استعلام عن نتيجة طالب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'أدخل رقم الاكتتاب الخاص بك',
                prefixIcon: const Icon(Icons.badge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _searchStudent,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: const Text('بحث عن النتيجة', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _searched
                  ? (_foundStudent == null
                      ? const Center(
                          child: Text(
                            'لم يتم العثور على طالب بهذا الرقم. تأكد من رقم الاكتتاب.',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : StudentResultCard(student: _foundStudent!))
                  : const Center(
                      child: Text(
                        'الرجاء إدخال رقم الاكتتاب لعرض النتيجة المفصلة.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ================= =================
// 5. بطاقة عرض النتيجة المفصلة للطالب
// ================= ================= =================

class StudentResultCard extends StatelessWidget {
  final Student student;

  const StudentResultCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final subjects = Student.getSubjectsForLevel(student.level);
    final isPassed = student.isPassed;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPassed ? Colors.green.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPassed ? Colors.green : Colors.red,
            ),
          ),
          child: Column(
            children: [
              Text(
                student.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'الصف: ${student.level == GradeLevel.baccalaureate ? "البكالوريا العلمية" : "التاسع الأساسي"} | رقم الاكتتاب: ${student.id}',
                style: const TextStyle(fontSize: 14),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'المجموع: ${student.totalScore.toInt()} / ${student.maxTotalScore.toInt()}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'النتيجة: ${isPassed ? "ناجح" : "راسب"}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isPassed ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'تفاصيل المواد والدرجات:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final sub = subjects[index];
              final score = student.grades[sub.name] ?? 0;
              final isSubPassed = score >= sub.minGrade;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(sub.name),
                  subtitle: Text(
                      'الحد الأدنى: ${sub.minGrade.toInt()} | العظمى: ${sub.maxGrade.toInt()}'),
                  trailing: Text(
                    '${score.toInt()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSubPassed ? Colors.black : Colors.red,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ================= ================= =================
// 6. لوحة تحكم المدير (محمية بكلمة سر)
// ================= ================= =================

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  void _openAddStudentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AddStudentForm(
          onAddStudent: (newStudent) {
            setState(() {
              globalStudentsList.add(newStudent);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إضافة الطالب بنجاح')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المدير'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddStudentModal,
        icon: const Icon(Icons.add),
        label: const Text('إضافة طالب جديد'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'قائمة الطلاب المسجلين في النظام:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: globalStudentsList.isEmpty
                  ? const Center(child: Text('لا يوجد طلاب مسجلون حالياً'))
                  : ListView.builder(
                      itemCount: globalStudentsList.length,
                      itemBuilder: (context, index) {
                        final student = globalStudentsList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(student.name),
                            subtitle: Text(
                                'رقم الاكتتاب: ${student.id} | المجموع: ${student.totalScore.toInt()}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  globalStudentsList.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ================= =================
// 7. نموذج إضافة طالب جديد (خاص بالمدير)
// ================= ================= =================

class AddStudentForm extends StatefulWidget {
  final Function(Student) onAddStudent;

  const AddStudentForm({super.key, required this.onAddStudent});

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  GradeLevel _selectedLevel = GradeLevel.baccalaureate;
  final Map<String, TextEditingController> _gradeControllers = {};

  @override
  void initState() {
    super.initState();
    _initGradeControllers();
  }

  void _initGradeControllers() {
    _gradeControllers.clear();
    final subjects = Student.getSubjectsForLevel(_selectedLevel);
    for (var sub in subjects) {
      _gradeControllers[sub.name] = TextEditingController();
    }
  }

  void _saveForm() {
    if (_nameController.text.isEmpty || _idController.text.isEmpty) return;

    final Map<String, double> grades = {};
    _gradeControllers.forEach((key, controller) {
      grades[key] = double.tryParse(controller.text) ?? 0;
    });

    final newStudent = Student(
      id: _idController.text.trim(),
      name: _nameController.text.trim(),
      level: _selectedLevel,
      grades: grades,
    );

    widget.onAddStudent(newStudent);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = Student.getSubjectsForLevel(_selectedLevel);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('إضافة طالب جديد للسيستم',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'اسم الطالب الثلاثي'),
          ),
          TextField(
            controller: _idController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'رقم الاكتتاب'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('الصف: '),
              ChoiceChip(
                label: const Text('البكالوريا'),
                selected: _selectedLevel == GradeLevel.baccalaureate,
                onSelected: (val) {
                  setState(() {
                    _selectedLevel = GradeLevel.baccalaureate;
                    _initGradeControllers();
                  });
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('التاسع'),
                selected: _selectedLevel == GradeLevel.ninth,
                onSelected: (val) {
                  setState(() {
                    _selectedLevel = GradeLevel.ninth;
                    _initGradeControllers();
                  });
                },
              ),
            ],
          ),
          const Divider(),
          const Text('علامات المواد:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final sub = subjects[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextField(
                    controller: _gradeControllers[sub.name],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText:
                          '${sub.name} (عظمى: ${sub.maxGrade.toInt()} - حد أدنى: ${sub.minGrade.toInt()})',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _saveForm,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text('حفظ الطالب'),
          ),
        ],
      ),
    );
  }
}
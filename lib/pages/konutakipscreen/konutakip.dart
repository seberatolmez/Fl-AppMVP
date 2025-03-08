import 'package:flutter/material.dart';
import 'package:takip_deneme/pages/konutakipscreen/models/database_helper.dart';
import 'models/subject.dart';

class SubjectTrackingScreen extends StatefulWidget {
  const SubjectTrackingScreen({super.key});

  @override
  State<SubjectTrackingScreen> createState() => _SubjectTrackingScreenState();
}

class _SubjectTrackingScreenState extends State<SubjectTrackingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['TYT', 'SAY','EA','SÖZ'];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Subject> tytSubjects = [];
  List<Subject> saySubjects = [];
  List<Subject> eaSubjects = [];
  List<Subject> sozSubjects = [];


  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoading = true);
    try {
      final tytList = await _dbHelper.getSubjects('TYT');
      final sayList = await _dbHelper.getSubjects('SAY');
      final eaList  = await _dbHelper.getSubjects('EA');
      final sozList  = await _dbHelper.getSubjects('SOZ');

      setState(() {
        tytSubjects = tytList;
        saySubjects = sayList;
        eaSubjects = eaList;
        sozSubjects = sozList;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading subjects: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateSubject(String examType, String subjectName) async {
    try {
      final subjects = examType == 'TYT' ? tytSubjects : examType == 'SAY' ?
      saySubjects : examType == 'EA'? eaSubjects : sozSubjects;

      final index = subjects.indexWhere((s) => s.name == subjectName);
      if (index != -1) {
        final updatedSubjects = await _dbHelper.getSubjects(examType);
        final updatedSubject = updatedSubjects.firstWhere((s) => s.name == subjectName);

        setState(() {
          if (examType == 'TYT') {
            tytSubjects[index] = updatedSubject;
          } else if(examType == 'SAY'){
            saySubjects[index] = updatedSubject;
          }else if(examType == 'EA'){
            eaSubjects[index] = updatedSubject;
          }else{
            sozSubjects[index] = updatedSubject;
          }
        });
      }
    } catch (e) {
      debugPrint('Error updating subject: $e');
    }
  }

  Future<void> _toggleTopicCompletion(String examType, String subjectName, String topicName, bool newValue, StateSetter dialogSetState) async {
    try {
      final subjects = examType == 'TYT' ? tytSubjects : examType == 'SAY' ?
      saySubjects : examType == 'EA'? eaSubjects : sozSubjects;

      final subject = subjects.firstWhere((s) => s.name == subjectName);
      final topic = subject.topics.firstWhere((t) => t.name == topicName);

      // Update the topic status in the database with the new parameters
      await _dbHelper.updateTopicStatus(subject.id, topicName, newValue);

      // Update both the dialog state and the main screen state
      dialogSetState(() {
        topic.isCompleted = newValue;
        subject.updateProgress();
      });

      setState(() {
        // This will update the progress bar in the main screen
        if (examType == 'TYT') {
          final index = tytSubjects.indexWhere((s) => s.name == subjectName);
          if (index != -1) {
            tytSubjects[index].progress = subject.progress;
          }
        } else if (examType == 'SAY') {
          final index = saySubjects.indexWhere((s) => s.name == subjectName);
          if (index != -1) {
            saySubjects[index].progress = subject.progress;
          }
        } else if (examType == 'EA') {
          final index = eaSubjects.indexWhere((s) => s.name == subjectName);
          if (index != -1) {
            eaSubjects[index].progress = subject.progress;
          }
        } else {
          final index = sozSubjects.indexWhere((s) => s.name == subjectName);
          if (index != -1) {
            sozSubjects[index].progress = subject.progress;
          }
        }
      });
    } catch (e) {
      debugPrint('Error toggling topic completion: $e');
    }
  }

  Future<void> _updateSubjectProgress(Subject subject) async {
    subject.updateProgress();
    await _dbHelper.updateSubjectProgress(subject.id, subject.progress);
    setState(() {});
  }

  Future<void> _handleTopicToggle(Subject subject, Topic topic) async {
    topic.isCompleted = !topic.isCompleted;
    await _dbHelper.updateTopicStatus(subject.id, topic.name, topic.isCompleted);
    await _updateSubjectProgress(subject);
  }

  Widget _buildSubjectCard(Subject subject) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          _showTopicsDialog(subject);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'İlerleme',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '%${(subject.progress * 100).toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 95, 51, 225),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      color: const Color.fromARGB(255, 95, 51, 225),
                      value: subject.progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTopicsDialog(Subject subject) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        subject.name,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 95, 51, 225),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      color: const Color.fromARGB(255, 95, 51, 225),
                      value: subject.progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'İlerleme: %${(subject.progress * 100).toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: subject.topics.length,
                    itemBuilder: (context, index) {
                      final topic = subject.topics[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: topic.isCompleted
                              ? const Color.fromARGB(255, 95, 51, 225).withOpacity(0.1)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CheckboxListTile(
                          activeColor: const Color.fromARGB(255, 95, 51, 225),
                          checkColor: Colors.white,
                          title: Text(
                            topic.name,
                            style: TextStyle(
                              color: topic.isCompleted ? Colors.grey : Colors.black,
                            ),
                          ),
                          value: topic.isCompleted,
                          onChanged: (bool? value) async {
                            if (value != null) {
                              await _dbHelper.updateTopicStatus(subject.id, topic.name, value);

                              setDialogState(() {
                                topic.isCompleted = value;
                                subject.updateProgress();
                              });

                              setState(() {
                                subject.progress = subject.progress;
                              });

                              await _dbHelper.updateSubjectProgress(subject.id, subject.progress);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Kapat',
                    style: TextStyle(
                      color: Color.fromARGB(255, 95, 51, 225),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 245, 249, 1) ,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 95, 51, 225),
        title: const Text(
          'Konu Takip',
          style: TextStyle(fontFamily: "Fonts",fontSize: 23,color: Colors.white),
        ),
        centerTitle: true,
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 4.0, color: Colors.white),
          ),
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(
            child: Text(
              tab,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Fonts",
              ),
            ),
          )).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: tytSubjects.length,
            itemBuilder: (context, index) {
              final subject = tytSubjects[index];
              return _buildSubjectCard(subject);
            },
          ),
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: saySubjects.length,
            itemBuilder: (context, index) {
              final subject = saySubjects[index];
              return _buildSubjectCard(subject);
            },
          ),
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: eaSubjects.length,
            itemBuilder: (context, index) {
              final subject = eaSubjects[index];
              return _buildSubjectCard(subject);
            },
          ),
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: sozSubjects.length,
            itemBuilder: (context, index) {
              final subject = sozSubjects[index];
              return _buildSubjectCard(subject);
            },
          ),
        ],
      ),
    );
  }
}

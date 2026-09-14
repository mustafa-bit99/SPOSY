import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const SuperMatchApp());
}

class SuperMatchApp extends StatelessWidget {
  const SuperMatchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'منصة المباريات التفاعلية',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cairo',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: Colors.cyanAccent,
        cardColor: const Color(0xFF1E293B),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MatchStreamAndChallengeTab(),
    const PredictionsAndAITab(),
    const LeaderboardTab(),
    const PostMatchRefereeTab(),
    const TeamSelectionAndStoryTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: "البث والتحدي"),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: "التوقع والتحليل"),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: "المتصدرين"),
          BottomNavigationBarItem(icon: Icon(Icons.gavel), label: "أنت الحكم"),
          BottomNavigationBarItem(icon: Icon(Icons.badge), label: "الفريق والستوري"),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// 1. شاشة البث والتحديات الخاطفة (Live Stream & Flash Challenge Overlay)
// -------------------------------------------------------------------
class MatchStreamAndChallengeTab extends StatefulWidget {
  const MatchStreamAndChallengeTab({Key? key}) : super(key: key);

  @override
  _MatchStreamAndChallengeTabState createState() => _MatchStreamAndChallengeTabState();
}

class _MatchStreamAndChallengeTabState extends State<MatchStreamAndChallengeTab> {
  bool showChallenge = false;
  int timerSeconds = 30;
  Timer? _timer;
  int userScore = 150;

  void triggerChallenge() {
    setState(() {
      showChallenge = true;
      timerSeconds = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timerSeconds > 0) {
        setState(() => timerSeconds--);
      } else {
        t.cancel();
        setState(() => showChallenge = false);
      }
    });
  }

  void answerChallenge(bool isCorrect) {
    _timer?.cancel();
    setState(() {
      showChallenge = false;
      if (isCorrect) userScore += 10;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? "إجابة رائعة! +10 نقاط 🚀" : "إجابة خاطئة، حظاً موفقاً بالكرة القادمة"),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("البث المباشر 🔴", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text("نقاطك: $userScore", style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // محاكاة فيديو البث المباشر
              Container(
                height: 230,
                width: double.infinity,
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.play_circle_fill, size: 70, color: Colors.cyanAccent),
                    Positioned(
                      top: 12, left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                        child: const Text("مباشر 4K", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: triggerChallenge,
                icon: const Icon(Icons.flash_on),
                label: const Text("محاكاة إطلاق تحدي خاطف من السيرفر", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),

          // كرت التحدي الخاطف المنبثق فوق مشغل الفيديو
          if (showChallenge)
            Positioned(
              top: 70, left: 16, right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amberAccent, width: 2),
                  boxShadow: [BoxShadow(color: Colors.amberAccent.withOpacity(0.4), blurRadius: 20)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("⚡ تحدي خاطف! (+10 نقاط)", style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                        Text("$timerSeconds ثانية", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text("هل ستُسفر هذه الركنية عن هدف؟ ⚽", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
                            onPressed: () => answerChallenge(true),
                            child: const Text("نعم، هدف!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
                            onPressed: () => answerChallenge(false),
                            child: const Text("لا، ستضيع", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// 2. شاشة التوقع الحصري والتحليل التكتيكي (AI & Predictions)
// -------------------------------------------------------------------
class PredictionsAndAITab extends StatefulWidget {
  const PredictionsAndAITab({Key? key}) : super(key: key);

  @override
  _PredictionsAndAITabState createState() => _PredictionsAndAITabState();
}

class _PredictionsAndAITabState extends State<PredictionsAndAITab> {
  int homeGoals = 2;
  int awayGoals = 1;
  String aiReport = "";
  bool isLoadingAI = false;

  void fetchAIReport() {
    setState(() => isLoadingAI = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoadingAI = false;
        aiReport = "🤖 تقرير Gemini التكتيكي:\nيعتمد برشلونة على الضغط العالي في ثلث الملعب الأخير، بينما يستغل ريال مدريد المساحات خلف الأظهرة عبر تحركات فينيسيوس المباشرة.";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("التوقع والتحليل الذكي 🧠", style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // قسم التوقع
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  const Text("توقع مباراة الكلاسيكو ⚽", style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _goalCounter("برشلونة", homeGoals, (v) => setState(() => homeGoals = v)),
                      const Text("VS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      _goalCounter("ريال مدريد", awayGoals, (v) => setState(() => awayGoals = v)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم تسجيل توقعك وحمايته بنجاح!🔒")));
                    },
                    child: const Text("حفظ التوقع", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // قسم التحليل التكتيكي بـ AI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                    onPressed: fetchAIReport,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text("توليد تقرير تكتيكي بـ Gemini AI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  if (isLoadingAI) const CircularProgressIndicator(),
                  if (aiReport.isNotEmpty && !isLoadingAI)
                    Text(aiReport, style: const TextStyle(color: Colors.white70, height: 1.5), textAlign: TextAlign.center),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _goalCounter(String team, int count, Function(int) onChange) {
    return Column(
      children: [
        Text(team, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.remove_circle), onPressed: () => count > 0 ? onChange(count - 1) : null),
            Text("$count", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.add_circle), onPressed: () => onChange(count + 1)),
          ],
        )
      ],
    );
  }
}

// -------------------------------------------------------------------
// 3. شاشة لوحة المتصدرين والألقاب (Leaderboard & Titles)
// -------------------------------------------------------------------
class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("جدول المتصدرين 🏆", style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAlignment: CrossAlignment.end,
            children: [
              _podiumItem("سامي", "الكتلوني", "120 ن", "2", Colors.grey, 65),
              _podiumItem("أحمد", "الملكي", "150 ن", "1", Colors.amber, 85),
              _podiumItem("خالد", "البافاري", "105 ن", "3", Colors.brown, 55),
            ],
          ),
          const SizedBox(height: 25),
          const Text("بقية المنافسين", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _leaderboardTile(4, "عمر", "الريدز", 95),
          _leaderboardTile(5, "حسن", "الزعيم", 88),
          _leaderboardTile(6, "فهد", "العالمي", 80),
        ],
      ),
    );
  }

  Widget _podiumItem(String name, String title, String pts, String rank, Color col, double radius) {
    return Column(
      children: [
        CircleAvatar(
          radius: radius / 2,
          backgroundColor: col,
          child: Text(rank, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text("[$title]", style: const TextStyle(color: Colors.amberAccent, fontSize: 11)),
        Text(pts, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _leaderboardTile(int rank, String name, String title, int pts) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Text("#$rank", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Text("[$title]", style: const TextStyle(color: Colors.amber, fontSize: 11)),
          const Spacer(),
          Text("$pts نقطة", style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// 4. شاشة "أنت الحكم" بعد المباراة (Post-Match Referee Poll)
// -------------------------------------------------------------------
class PostMatchRefereeTab extends StatefulWidget {
  const PostMatchRefereeTab({Key? key}) : super(key: key);

  @override
  _PostMatchRefereeTabState createState() => _PostMatchRefereeTabState();
}

class _PostMatchRefereeTabState extends State<PostMatchRefereeTab> {
  int yes = 1420;
  int no = 380;
  bool voted = false;

  @override
  Widget build(BuildContext context) {
    int total = yes + no;
    double yesPct = (yes / total) * 100;

    return Scaffold(
      appBar: AppBar(title: const Text("أنت الحكم ⚖️", style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAlignment: CrossAlignment.start,
                children: [
                  const Text("قضية المباراة: هل كانت حالة الطرد في الدقيقة 78 صحيحة؟", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 16),
                  if (!voted) ...[
                    Row(
                      children: [
                        Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () => setState(() { yes++; voted = true; }), child: const Text("قرار صحيح 👍"))),
                        const SizedBox(width: 10),
                        Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => setState(() { no++; voted = true; }), child: const Text("قرار خاطئ 👎"))),
                      ],
                    )
                  ] else ...[
                    Text("رأي الجمهور: ${yesPct.toStringAsFixed(1)}% يرونها صحيحة", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 14,
                        child: Row(
                          children: [
                            Expanded(flex: yes, child: Container(color: Colors.green)),
                            Expanded(flex: no, child: Container(color: Colors.red)),
                          ],
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// 5. شاشة اختيار الفريق ومولد الستوري (Team Picker & Story)
// -------------------------------------------------------------------
class TeamSelectionAndStoryTab extends StatefulWidget {
  const TeamSelectionAndStoryTab({Key? key}) : super(key: key);

  @override
  _TeamSelectionAndStoryTabState createState() => _TeamSelectionAndStoryTabState();
}

class _TeamSelectionAndStoryTabState extends State<TeamSelectionAndStoryTab> {
  String selectedTitle = "الملكي";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الفريق والستوري 👑", style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("لقبك الانتمائي الحالي: [$selectedTitle]", style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(label: const Text("برشلونة (الكتلوني)"), onPressed: () => setState(() => selectedTitle = "الكتلوني")),
                ActionChip(label: const Text("ريال مدريد (الملكي)"), onPressed: () => setState(() => selectedTitle = "الملكي")),
                ActionChip(label: const Text("بايرن (البافاري)"), onPressed: () => setState(() => selectedTitle = "البافاري")),
                ActionChip(label: const Text("ليفربول (الريدز)"), onPressed: () => setState(() => selectedTitle = "الريدز")),
              ],
            ),
            const SizedBox(height: 25),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),
            const Text("معاينة بطاقة الستوري الفيروسية (TikTok / IG)", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            
            // معاينة بطاقة الستوري
            Container(
              width: 230,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF0284C7)]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyanAccent),
              ),
              child: Column(
                children: [
                  Text("[$selectedTitle]", style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text("أحمد - توقع المباراة", style: const TextStyle(color: Colors.white, fontSize: 13)),
                  const SizedBox(height: 12),
                  const Text("\"توقعت النتيجة 2-1 وحصدت +5 نقاط! 🏆\"", textAlign: TextAlign.center, style: TextStyle(color: Colors.cyanAccent, fontSize: 12, fontStyle: FontStyle.italic)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

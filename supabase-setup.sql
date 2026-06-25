-- ① problems 테이블
CREATE TABLE problems (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  unit         TEXT NOT NULL,
  image_url    TEXT NOT NULL,
  order_number INTEGER NOT NULL,
  answer       INTEGER CHECK (answer BETWEEN 1 AND 5),
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ② submissions 테이블
CREATE TABLE submissions (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  student_name  TEXT NOT NULL,
  unit          TEXT NOT NULL,
  answers       JSONB NOT NULL,
  submitted_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ③ RLS 활성화
ALTER TABLE problems    ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

-- ④ problems 정책: 누구나 읽기, 로그인한 교사만 쓰기
CREATE POLICY "problems_read"   ON problems FOR SELECT USING (true);
CREATE POLICY "problems_insert" ON problems FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);
CREATE POLICY "problems_update" ON problems FOR UPDATE USING (auth.uid() IS NOT NULL);
CREATE POLICY "problems_delete" ON problems FOR DELETE USING (auth.uid() IS NOT NULL);

-- ⑤ submissions 정책: 누구나 제출, 로그인한 교사만 조회
CREATE POLICY "submissions_insert" ON submissions FOR INSERT WITH CHECK (true);
CREATE POLICY "submissions_read"   ON submissions FOR SELECT USING (auth.uid() IS NOT NULL);

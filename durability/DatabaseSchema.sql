-- Create assessment_results table
CREATE TABLE assessment_results (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    durability_score DECIMAL(5,2),
    range_of_motion DECIMAL(3,2),
    flexibility DECIMAL(3,2),
    mobility DECIMAL(3,2),
    functional_strength DECIMAL(3,2),
    aerobic_capacity DECIMAL(3,2),
    exercises JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create joint_metrics table
CREATE TABLE joint_metrics (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    assessment_id UUID REFERENCES assessment_results(id),
    joint_name TEXT NOT NULL,
    muscle_group TEXT,
    metric_type TEXT NOT NULL,
    metric_name TEXT NOT NULL,
    value DECIMAL(8,3),
    unit TEXT,
    target_range_min DECIMAL(8,3),
    target_range_max DECIMAL(8,3),
    is_optimal BOOLEAN,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create movement_metrics table
CREATE TABLE movement_metrics (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    assessment_id UUID REFERENCES assessment_results(id),
    exercise_name TEXT NOT NULL,
    exercise_id TEXT NOT NULL,
    body_part TEXT,
    difficulty TEXT CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
    is_completed BOOLEAN DEFAULT FALSE,
    video_url TEXT,
    notes TEXT,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create injuries table
CREATE TABLE injuries (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    injury_type TEXT NOT NULL,
    severity TEXT CHECK (severity IN ('mild', 'moderate', 'severe')),
    recovery_status TEXT CHECK (recovery_status IN ('active', 'recovering', 'resolved')),
    year INTEGER,
    description TEXT,
    affected_body_part TEXT,
    is_active BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create goals table
CREATE TABLE goals (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    description TEXT NOT NULL,
    priority TEXT CHECK (priority IN ('low', 'medium', 'high')),
    target_date DATE,
    is_achieved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create training_sessions table
CREATE TABLE training_sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    session_date DATE NOT NULL,
    session_type TEXT,
    duration_minutes INTEGER,
    intensity TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_assessment_results_user_id ON assessment_results(user_id);
CREATE INDEX idx_assessment_results_date ON assessment_results(date);
CREATE INDEX idx_joint_metrics_user_assessment ON joint_metrics(user_id, assessment_id);
CREATE INDEX idx_joint_metrics_joint_type ON joint_metrics(joint_name, metric_type);
CREATE INDEX idx_movement_metrics_user_assessment ON movement_metrics(user_id, assessment_id);
CREATE INDEX idx_injuries_user_id ON injuries(user_id);
CREATE INDEX idx_goals_user_id ON goals(user_id);
CREATE INDEX idx_training_sessions_user_id ON training_sessions(user_id);

-- Enable RLS on all tables
ALTER TABLE assessment_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE joint_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE movement_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE injuries ENABLE ROW LEVEL SECURITY;
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE training_sessions ENABLE ROW LEVEL SECURITY;

-- Row Level Security Policies
CREATE POLICY "Users can view own assessment results" ON assessment_results
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own assessment results" ON assessment_results
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own joint metrics" ON joint_metrics
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own joint metrics" ON joint_metrics
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own movement metrics" ON movement_metrics
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own movement metrics" ON movement_metrics
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own injuries" ON injuries
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own injuries" ON injuries
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own goals" ON goals
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own goals" ON goals
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own training sessions" ON training_sessions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own training sessions" ON training_sessions
    FOR INSERT WITH CHECK (auth.uid() = user_id); 
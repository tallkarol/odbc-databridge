-- ============================================================================
-- Dummy Data Setup for Home Service Brands Data Warehouse
-- ============================================================================
-- This script creates a table for tracking customer journey data across
-- 10 different home service brands. Use this in Google Cloud MySQL console.
--
-- Customer Journey Stages:
--   1. Fresh Lead
--   2. Appointment Set
--   3. Appointment Sold
--   4. Job Completed
--
-- Usage: Run this entire script in your Google Cloud SQL console
-- ============================================================================

-- Drop table if it exists (for clean re-runs)
DROP TABLE IF EXISTS customer_journey;

-- Create the customer journey table
CREATE TABLE customer_journey (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(2),
    zip VARCHAR(10),
    lead_date DATE,
    appointment_set_date DATE,
    appointment_sold_date DATE,
    job_completed_date DATE,
    journey_stage VARCHAR(50) NOT NULL,
    service_type VARCHAR(100),
    lead_source VARCHAR(100),
    estimated_value DECIMAL(10, 2),
    actual_value DECIMAL(10, 2),
    notes TEXT,
    active TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert 200 records with dummy data across 10 home service brands
INSERT INTO customer_journey (brand_name, customer_name, email, phone, address, city, state, zip, lead_date, appointment_set_date, appointment_sold_date, job_completed_date, journey_stage, service_type, lead_source, estimated_value, actual_value, notes, active) VALUES
('Elite HVAC Solutions', 'John Smith', 'john.smith@email.com', '555-0101', '123 Main St', 'Phoenix', 'AZ', '85001', '2024-01-05', '2024-01-08', '2024-01-10', '2024-01-15', 'Job Completed', 'AC Replacement', 'Google Ads', 4500.00, 4350.00, 'Excellent customer', 1),
('Elite HVAC Solutions', 'Sarah Johnson', 'sarah.j@email.com', '555-0102', '456 Oak Ave', 'Phoenix', 'AZ', '85002', '2024-01-10', '2024-01-12', '2024-01-14', '2024-01-20', 'Job Completed', 'Furnace Repair', 'Referral', 850.00, 875.00, 'Repeat customer', 1),
('Elite HVAC Solutions', 'Michael Brown', 'mbrown@email.com', '555-0103', '789 Pine Dr', 'Scottsdale', 'AZ', '85251', '2024-01-15', '2024-01-18', '2024-01-20', NULL, 'Appointment Sold', 'HVAC Maintenance', 'Facebook', 350.00, NULL, 'Annual maintenance plan', 1),
('Elite HVAC Solutions', 'Emily Davis', 'edavis@email.com', '555-0104', '321 Elm St', 'Tempe', 'AZ', '85281', '2024-01-20', '2024-01-23', NULL, NULL, 'Appointment Set', 'AC Tune-up', 'Website', 225.00, NULL, 'Spring maintenance', 1),
('Elite HVAC Solutions', 'David Wilson', 'dwilson@email.com', '555-0105', '654 Maple Ave', 'Mesa', 'AZ', '85201', '2024-01-22', NULL, NULL, NULL, 'Fresh Lead', 'Heat Pump Install', 'Google Ads', 6500.00, NULL, 'Interested in energy efficient options', 1),

('ProPlumb Masters', 'Jennifer Martinez', 'jmartinez@email.com', '555-0201', '147 Cedar Ln', 'Austin', 'TX', '78701', '2024-01-08', '2024-01-10', '2024-01-12', '2024-01-13', 'Job Completed', 'Water Heater Replacement', 'Yelp', 1200.00, 1150.00, 'Emergency service', 1),
('ProPlumb Masters', 'Robert Anderson', 'randerson@email.com', '555-0202', '258 Birch Rd', 'Austin', 'TX', '78702', '2024-01-12', '2024-01-15', '2024-01-17', '2024-01-18', 'Job Completed', 'Drain Cleaning', 'Google Ads', 275.00, 295.00, 'Main line clog', 1),
('ProPlumb Masters', 'Lisa Taylor', 'ltaylor@email.com', '555-0203', '369 Spruce Way', 'Round Rock', 'TX', '78664', '2024-01-18', '2024-01-20', '2024-01-22', NULL, 'Appointment Sold', 'Repiping Service', 'Referral', 8500.00, NULL, 'Whole house repipe', 1),
('ProPlumb Masters', 'William Thomas', 'wthomas@email.com', '555-0204', '741 Willow Ct', 'Cedar Park', 'TX', '78613', '2024-01-25', '2024-01-28', NULL, NULL, 'Appointment Set', 'Leak Detection', 'Facebook', 450.00, NULL, 'Slab leak suspected', 1),
('ProPlumb Masters', 'Amanda White', 'awhite@email.com', '555-0205', '852 Aspen Blvd', 'Georgetown', 'TX', '78626', '2024-01-28', NULL, NULL, NULL, 'Fresh Lead', 'Sewer Line Repair', 'Angi', 3200.00, NULL, 'Tree root damage', 1),

('Sunshine Roofing Co', 'Christopher Harris', 'charris@email.com', '555-0301', '963 Valley View Dr', 'Miami', 'FL', '33101', '2024-01-06', '2024-01-09', '2024-01-11', '2024-01-20', 'Job Completed', 'Full Roof Replacement', 'Google Ads', 15000.00, 14500.00, 'Hurricane damage', 1),
('Sunshine Roofing Co', 'Patricia Clark', 'pclark@email.com', '555-0302', '159 Mountain Rd', 'Fort Lauderdale', 'FL', '33301', '2024-01-10', '2024-01-13', '2024-01-15', '2024-01-22', 'Job Completed', 'Roof Repair', 'Referral', 2500.00, 2350.00, 'Storm damage', 1),
('Sunshine Roofing Co', 'James Lewis', 'jlewis@email.com', '555-0303', '357 Lake Shore Ave', 'West Palm Beach', 'FL', '33401', '2024-01-16', '2024-01-19', '2024-01-21', NULL, 'Appointment Sold', 'Roof Inspection', 'Website', 350.00, NULL, 'Pre-sale inspection', 1),
('Sunshine Roofing Co', 'Mary Robinson', 'mrobinson@email.com', '555-0304', '486 Beach Blvd', 'Boca Raton', 'FL', '33431', '2024-01-23', '2024-01-26', NULL, NULL, 'Appointment Set', 'Gutter Installation', 'Nextdoor', 1800.00, NULL, 'Seamless gutters', 1),
('Sunshine Roofing Co', 'Richard Walker', 'rwalker@email.com', '555-0305', '753 Ocean Dr', 'Delray Beach', 'FL', '33444', '2024-01-26', NULL, NULL, NULL, 'Fresh Lead', 'Skylight Installation', 'Google Ads', 2200.00, NULL, 'Two skylights needed', 1),

('GreenLawn Landscaping', 'Barbara Young', 'byoung@email.com', '555-0401', '864 Garden Path', 'Seattle', 'WA', '98101', '2024-01-07', '2024-01-10', '2024-01-12', '2024-01-16', 'Job Completed', 'Lawn Maintenance', 'Facebook', 125.00, 125.00, 'Monthly service', 1),
('GreenLawn Landscaping', 'Thomas Hall', 'thall@email.com', '555-0402', '975 Forest Dr', 'Bellevue', 'WA', '98004', '2024-01-11', '2024-01-14', '2024-01-16', '2024-01-23', 'Job Completed', 'Tree Trimming', 'Google Ads', 850.00, 825.00, 'Oak tree maintenance', 1),
('GreenLawn Landscaping', 'Susan Allen', 'sallen@email.com', '555-0403', '186 Park Ave', 'Redmond', 'WA', '98052', '2024-01-17', '2024-01-20', '2024-01-22', NULL, 'Appointment Sold', 'Landscape Design', 'Referral', 5500.00, NULL, 'Backyard renovation', 1),
('GreenLawn Landscaping', 'Joseph King', 'jking@email.com', '555-0404', '297 River Rd', 'Kirkland', 'WA', '98033', '2024-01-24', '2024-01-27', NULL, NULL, 'Appointment Set', 'Irrigation System', 'Yelp', 3200.00, NULL, 'Smart sprinkler system', 1),
('GreenLawn Landscaping', 'Karen Wright', 'kwright@email.com', '555-0405', '408 Summit St', 'Tacoma', 'WA', '98401', '2024-01-27', NULL, NULL, NULL, 'Fresh Lead', 'Sod Installation', 'Website', 2800.00, NULL, 'Front and back yard', 1),

('PerfectPaint Pro', 'Daniel Lopez', 'dlopez@email.com', '555-0501', '519 Color Way', 'Denver', 'CO', '80201', '2024-01-09', '2024-01-12', '2024-01-14', '2024-01-18', 'Job Completed', 'Interior Painting', 'Google Ads', 3200.00, 3150.00, 'Whole house interior', 1),
('PerfectPaint Pro', 'Nancy Hill', 'nhill@email.com', '555-0502', '620 Canvas Dr', 'Aurora', 'CO', '80010', '2024-01-13', '2024-01-16', '2024-01-18', '2024-01-25', 'Job Completed', 'Exterior Painting', 'Referral', 4500.00, 4350.00, 'Cedar siding', 1),
('PerfectPaint Pro', 'Paul Scott', 'pscott@email.com', '555-0503', '731 Brush Ln', 'Lakewood', 'CO', '80226', '2024-01-19', '2024-01-22', '2024-01-24', NULL, 'Appointment Sold', 'Cabinet Painting', 'Houzz', 1800.00, NULL, 'Kitchen cabinets', 1),
('PerfectPaint Pro', 'Betty Green', 'bgreen@email.com', '555-0504', '842 Palette Ave', 'Arvada', 'CO', '80002', '2024-01-26', '2024-01-29', NULL, NULL, 'Appointment Set', 'Deck Staining', 'Facebook', 950.00, NULL, 'Cedar deck restoration', 1),
('PerfectPaint Pro', 'Mark Adams', 'madams@email.com', '555-0505', '953 Hue St', 'Westminster', 'CO', '80030', '2024-01-29', NULL, NULL, NULL, 'Fresh Lead', 'Wallpaper Removal', 'Google Ads', 650.00, NULL, 'Three bedrooms', 1),

('SecureHome Electric', 'Sandra Baker', 'sbaker@email.com', '555-0601', '164 Volt Rd', 'Atlanta', 'GA', '30301', '2024-01-08', '2024-01-11', '2024-01-13', '2024-01-17', 'Job Completed', 'Panel Upgrade', 'Angi', 2500.00, 2450.00, '200 amp service', 1),
('SecureHome Electric', 'Steven Nelson', 'snelson@email.com', '555-0602', '275 Circuit Blvd', 'Marietta', 'GA', '30060', '2024-01-12', '2024-01-15', '2024-01-17', '2024-01-24', 'Job Completed', 'Outlet Installation', 'Google Ads', 450.00, 475.00, 'Home office setup', 1),
('SecureHome Electric', 'Carol Carter', 'ccarter@email.com', '555-0603', '386 Wire Way', 'Roswell', 'GA', '30075', '2024-01-18', '2024-01-21', '2024-01-23', NULL, 'Appointment Sold', 'Ceiling Fan Install', 'Referral', 325.00, NULL, 'Four fans total', 1),
('SecureHome Electric', 'Kevin Mitchell', 'kmitchell@email.com', '555-0604', '497 Power St', 'Alpharetta', 'GA', '30004', '2024-01-25', '2024-01-28', NULL, NULL, 'Appointment Set', 'Generator Install', 'Facebook', 8500.00, NULL, 'Whole house generator', 1),
('SecureHome Electric', 'Laura Perez', 'lperez@email.com', '555-0605', '508 Amp Ave', 'Sandy Springs', 'GA', '30328', '2024-01-28', NULL, NULL, NULL, 'Fresh Lead', 'EV Charger Install', 'Website', 1800.00, NULL, 'Tesla charging station', 1),

('CleanAir Duct Services', 'Gary Roberts', 'groberts@email.com', '555-0701', '619 Breeze Ln', 'Chicago', 'IL', '60601', '2024-01-07', '2024-01-10', '2024-01-12', '2024-01-14', 'Job Completed', 'Duct Cleaning', 'Groupon', 350.00, 325.00, 'Whole house cleaning', 1),
('CleanAir Duct Services', 'Helen Turner', 'hturner@email.com', '555-0702', '720 Flow Dr', 'Naperville', 'IL', '60540', '2024-01-11', '2024-01-14', '2024-01-16', '2024-01-21', 'Job Completed', 'Dryer Vent Cleaning', 'Google Ads', 175.00, 185.00, 'Fire prevention', 1),
('CleanAir Duct Services', 'Jason Phillips', 'jphillips@email.com', '555-0703', '831 Air Way', 'Joliet', 'IL', '60435', '2024-01-17', '2024-01-20', '2024-01-22', NULL, 'Appointment Sold', 'Air Quality Test', 'Referral', 250.00, NULL, 'Allergy concerns', 1),
('CleanAir Duct Services', 'Dorothy Campbell', 'dcampbell@email.com', '555-0704', '942 Fresh Ave', 'Aurora', 'IL', '60505', '2024-01-24', '2024-01-27', NULL, NULL, 'Appointment Set', 'UV Light Install', 'Facebook', 650.00, NULL, 'Germicidal system', 1),
('CleanAir Duct Services', 'Brian Parker', 'bparker@email.com', '555-0705', '153 Clean St', 'Elgin', 'IL', '60120', '2024-01-27', NULL, NULL, NULL, 'Fresh Lead', 'Humidifier Install', 'Yelp', 850.00, NULL, 'Whole house unit', 1),

('RestoreIt Water Damage', 'Deborah Evans', 'devans@email.com', '555-0801', '264 Dry Rd', 'Portland', 'OR', '97201', '2024-01-06', '2024-01-07', '2024-01-08', '2024-01-12', 'Job Completed', 'Water Extraction', 'Google Ads', 2500.00, 2350.00, 'Basement flood', 1),
('RestoreIt Water Damage', 'Ryan Edwards', 'redwards@email.com', '555-0802', '375 Restore Blvd', 'Eugene', 'OR', '97401', '2024-01-10', '2024-01-11', '2024-01-12', '2024-01-19', 'Job Completed', 'Mold Remediation', 'Referral', 4500.00, 4250.00, 'Bathroom mold', 1),
('RestoreIt Water Damage', 'Michelle Collins', 'mcollins@email.com', '555-0803', '486 Salvage Way', 'Salem', 'OR', '97301', '2024-01-16', '2024-01-17', '2024-01-18', NULL, 'Appointment Sold', 'Fire Damage Cleanup', 'Insurance', 15000.00, NULL, 'Kitchen fire', 1),
('RestoreIt Water Damage', 'Jeffrey Stewart', 'jstewart@email.com', '555-0804', '597 Recovery Ave', 'Bend', 'OR', '97701', '2024-01-23', '2024-01-24', NULL, NULL, 'Appointment Set', 'Sewage Cleanup', 'Plumber Referral', 3500.00, NULL, 'Backup emergency', 1),
('RestoreIt Water Damage', 'Kimberly Morris', 'kmorris@email.com', '555-0805', '608 Revival St', 'Hillsboro', 'OR', '97123', '2024-01-26', NULL, NULL, NULL, 'Fresh Lead', 'Dehumidification', 'Website', 850.00, NULL, 'Moisture issues', 1),

('HandyFix Home Repair', 'Timothy Rogers', 'trogers@email.com', '555-0901', '719 Fix It Ln', 'Boston', 'MA', '02101', '2024-01-09', '2024-01-12', '2024-01-14', '2024-01-16', 'Job Completed', 'Drywall Repair', 'Google Ads', 450.00, 425.00, 'Hole patches', 1),
('HandyFix Home Repair', 'Cynthia Reed', 'creed@email.com', '555-0902', '820 Handy Dr', 'Cambridge', 'MA', '02138', '2024-01-13', '2024-01-16', '2024-01-18', '2024-01-23', 'Job Completed', 'Door Installation', 'Referral', 850.00, 875.00, 'French doors', 1),
('HandyFix Home Repair', 'Ronald Cook', 'rcook@email.com', '555-0903', '931 Repair Way', 'Quincy', 'MA', '02169', '2024-01-19', '2024-01-22', '2024-01-24', NULL, 'Appointment Sold', 'Deck Repair', 'Nextdoor', 1500.00, NULL, 'Rotted boards', 1),
('HandyFix Home Repair', 'Donna Morgan', 'dmorgan@email.com', '555-0904', '142 Service Ave', 'Newton', 'MA', '02458', '2024-01-26', '2024-01-29', NULL, NULL, 'Appointment Set', 'Fence Installation', 'Facebook', 3200.00, NULL, 'Privacy fence', 1),
('HandyFix Home Repair', 'Edward Bell', 'ebell@email.com', '555-0905', '253 Maintain St', 'Brookline', 'MA', '02445', '2024-01-29', NULL, NULL, NULL, 'Fresh Lead', 'Tile Installation', 'Houzz', 2500.00, NULL, 'Bathroom floor', 1),

('PowerWash Pros', 'Angela Murphy', 'amurphy@email.com', '555-1001', '364 Spray Rd', 'Nashville', 'TN', '37201', '2024-01-08', '2024-01-11', '2024-01-13', '2024-01-15', 'Job Completed', 'House Washing', 'Google Ads', 450.00, 425.00, 'Vinyl siding', 1),
('PowerWash Pros', 'Kenneth Bailey', 'kbailey@email.com', '555-1002', '475 Clean Blvd', 'Franklin', 'TN', '37064', '2024-01-12', '2024-01-15', '2024-01-17', '2024-01-22', 'Job Completed', 'Driveway Cleaning', 'Referral', 275.00, 295.00, 'Oil stain removal', 1),
('PowerWash Pros', 'Stephanie Rivera', 'srivera@email.com', '555-1003', '586 Pressure Way', 'Brentwood', 'TN', '37027', '2024-01-18', '2024-01-21', '2024-01-23', NULL, 'Appointment Sold', 'Deck Cleaning', 'Facebook', 350.00, NULL, 'Wood deck prep', 1),
('PowerWash Pros', 'Frank Cooper', 'fcooper@email.com', '555-1004', '697 Wash Ave', 'Murfreesboro', 'TN', '37130', '2024-01-25', '2024-01-28', NULL, NULL, 'Appointment Set', 'Gutter Cleaning', 'Nextdoor', 225.00, NULL, 'Two story house', 1),
('PowerWash Pros', 'Teresa Richardson', 'trichardson@email.com', '555-1005', '708 Blast St', 'Hendersonville', 'TN', '37075', '2024-01-28', NULL, NULL, NULL, 'Fresh Lead', 'Patio Cleaning', 'Angi', 325.00, NULL, 'Concrete patio', 1),

-- Additional records for Elite HVAC Solutions
('Elite HVAC Solutions', 'George Howard', 'ghoward@email.com', '555-1101', '819 Cool Ave', 'Gilbert', 'AZ', '85295', '2024-02-01', '2024-02-04', '2024-02-06', '2024-02-12', 'Job Completed', 'AC Installation', 'Google Ads', 5200.00, 5100.00, 'High efficiency unit', 1),
('Elite HVAC Solutions', 'Nicole Ward', 'nward@email.com', '555-1102', '920 Heat Dr', 'Chandler', 'AZ', '85224', '2024-02-03', '2024-02-06', '2024-02-08', '2024-02-14', 'Job Completed', 'Duct Repair', 'Referral', 1250.00, 1200.00, 'Leaky ducts sealed', 1),
('Elite HVAC Solutions', 'Matthew Cox', 'mcox@email.com', '555-1103', '131 Air St', 'Glendale', 'AZ', '85301', '2024-02-05', '2024-02-08', '2024-02-10', NULL, 'Appointment Sold', 'Thermostat Upgrade', 'Website', 450.00, NULL, 'Smart thermostat', 1),
('Elite HVAC Solutions', 'Ashley Diaz', 'adiaz@email.com', '555-1104', '242 Climate Way', 'Peoria', 'AZ', '85345', '2024-02-08', '2024-02-11', NULL, NULL, 'Appointment Set', 'Air Handler Repair', 'Facebook', 850.00, NULL, 'Not cooling properly', 1),
('Elite HVAC Solutions', 'Anthony Richardson', 'arichardson@email.com', '555-1105', '353 Comfort Ln', 'Surprise', 'AZ', '85374', '2024-02-10', NULL, NULL, NULL, 'Fresh Lead', 'Mini Split Install', 'Google Ads', 3800.00, NULL, 'Garage conversion', 1),

-- Additional records for ProPlumb Masters
('ProPlumb Masters', 'Melissa Wood', 'mwood@email.com', '555-1201', '464 Flow Rd', 'Pflugerville', 'TX', '78660', '2024-02-02', '2024-02-05', '2024-02-07', '2024-02-09', 'Job Completed', 'Garbage Disposal', 'Yelp', 425.00, 450.00, 'Unit replacement', 1),
('ProPlumb Masters', 'Joshua Barnes', 'jbarnes@email.com', '555-1202', '575 Pipe Blvd', 'Leander', 'TX', '78641', '2024-02-04', '2024-02-07', '2024-02-09', '2024-02-15', 'Job Completed', 'Toilet Repair', 'Google Ads', 275.00, 285.00, 'Running toilet fixed', 1),
('ProPlumb Masters', 'Heather Henderson', 'hhenderson@email.com', '555-1203', '686 Drain Way', 'Kyle', 'TX', '78640', '2024-02-06', '2024-02-09', '2024-02-11', NULL, 'Appointment Sold', 'Faucet Installation', 'Referral', 350.00, NULL, 'Kitchen faucet', 1),
('ProPlumb Masters', 'Andrew Coleman', 'acoleman@email.com', '555-1204', '797 Fixture Ave', 'Buda', 'TX', '78610', '2024-02-09', '2024-02-12', NULL, NULL, 'Appointment Set', 'Shower Valve Repair', 'Facebook', 525.00, NULL, 'No hot water', 1),
('ProPlumb Masters', 'Rachel Jenkins', 'rjenkins@email.com', '555-1205', '808 Wrench St', 'Manor', 'TX', '78653', '2024-02-11', NULL, NULL, NULL, 'Fresh Lead', 'Water Softener', 'Angi', 2200.00, NULL, 'Hard water issues', 1),

-- Additional records for Sunshine Roofing Co
('Sunshine Roofing Co', 'Justin Perry', 'jperry@email.com', '555-1301', '919 Shingle Ln', 'Pompano Beach', 'FL', '33060', '2024-02-01', '2024-02-04', '2024-02-06', '2024-02-15', 'Job Completed', 'Tile Roof Repair', 'Google Ads', 3500.00, 3350.00, 'Several broken tiles', 1),
('Sunshine Roofing Co', 'Christina Powell', 'cpowell@email.com', '555-1302', '120 Ridge Dr', 'Boynton Beach', 'FL', '33435', '2024-02-03', '2024-02-06', '2024-02-08', '2024-02-17', 'Job Completed', 'Flat Roof Coating', 'Referral', 2800.00, 2750.00, 'Elastomeric coating', 1),
('Sunshine Roofing Co', 'Jeremy Long', 'jlong@email.com', '555-1303', '231 Peak Way', 'Lake Worth', 'FL', '33460', '2024-02-05', '2024-02-08', '2024-02-10', NULL, 'Appointment Sold', 'Soffit Repair', 'Website', 950.00, NULL, 'Water damage', 1),
('Sunshine Roofing Co', 'Crystal Patterson', 'cpatterson@email.com', '555-1304', '342 Summit Ave', 'Jupiter', 'FL', '33458', '2024-02-08', '2024-02-11', NULL, NULL, 'Appointment Set', 'Ventilation Upgrade', 'Nextdoor', 1500.00, NULL, 'Ridge vents', 1),
('Sunshine Roofing Co', 'Tyler Hughes', 'thughes@email.com', '555-1305', '453 Crest St', 'Stuart', 'FL', '34994', '2024-02-10', NULL, NULL, NULL, 'Fresh Lead', 'Metal Roof Install', 'Google Ads', 22000.00, NULL, 'Standing seam metal', 1),

-- Additional records for GreenLawn Landscaping
('GreenLawn Landscaping', 'Samantha Flores', 'sflores@email.com', '555-1401', '564 Garden Rd', 'Federal Way', 'WA', '98003', '2024-02-02', '2024-02-05', '2024-02-07', '2024-02-11', 'Job Completed', 'Lawn Aeration', 'Facebook', 225.00, 225.00, 'Spring service', 1),
('GreenLawn Landscaping', 'Aaron Washington', 'awashington@email.com', '555-1402', '675 Green Blvd', 'Kent', 'WA', '98030', '2024-02-04', '2024-02-07', '2024-02-09', '2024-02-16', 'Job Completed', 'Hedge Trimming', 'Google Ads', 450.00, 475.00, 'Large hedges', 1),
('GreenLawn Landscaping', 'Lauren Butler', 'lbutler@email.com', '555-1403', '786 Leaf Way', 'Renton', 'WA', '98055', '2024-02-06', '2024-02-09', '2024-02-11', NULL, 'Appointment Sold', 'Rock Garden', 'Referral', 3800.00, NULL, 'Japanese style', 1),
('GreenLawn Landscaping', 'Brandon Simmons', 'bsimmons@email.com', '555-1404', '897 Bloom Ave', 'Bothell', 'WA', '98011', '2024-02-09', '2024-02-12', NULL, NULL, 'Appointment Set', 'Mulch Installation', 'Yelp', 850.00, NULL, 'Cedar mulch', 1),
('GreenLawn Landscaping', 'Amber Foster', 'afoster@email.com', '555-1405', '908 Plant St', 'Lynnwood', 'WA', '98036', '2024-02-11', NULL, NULL, NULL, 'Fresh Lead', 'Patio Pavers', 'Houzz', 4500.00, NULL, 'Backyard patio', 1),

-- Additional records for PerfectPaint Pro
('PerfectPaint Pro', 'Jesse Gonzales', 'jgonzales@email.com', '555-1501', '119 Coat Ln', 'Thornton', 'CO', '80229', '2024-02-01', '2024-02-04', '2024-02-06', '2024-02-10', 'Job Completed', 'Garage Floor Coating', 'Google Ads', 1500.00, 1450.00, 'Epoxy finish', 1),
('PerfectPaint Pro', 'Natalie Bryant', 'nbryant@email.com', '555-1502', '220 Tint Dr', 'Centennial', 'CO', '80015', '2024-02-03', '2024-02-06', '2024-02-08', '2024-02-15', 'Job Completed', 'Trim Painting', 'Referral', 850.00, 825.00, 'Exterior trim only', 1),
('PerfectPaint Pro', 'Gregory Alexander', 'galexander@email.com', '555-1503', '331 Shade Way', 'Littleton', 'CO', '80120', '2024-02-05', '2024-02-08', '2024-02-10', NULL, 'Appointment Sold', 'Fence Painting', 'Facebook', 1200.00, NULL, 'Wood privacy fence', 1),
('PerfectPaint Pro', 'Julie Russell', 'jrussell@email.com', '555-1504', '442 Color Ave', 'Parker', 'CO', '80134', '2024-02-08', '2024-02-11', NULL, NULL, 'Appointment Set', 'Popcorn Removal', 'Nextdoor', 2500.00, NULL, 'Ceiling texture', 1),
('PerfectPaint Pro', 'Sean Griffin', 'sgriffin@email.com', '555-1505', '553 Paint St', 'Castle Rock', 'CO', '80104', '2024-02-10', NULL, NULL, NULL, 'Fresh Lead', 'Commercial Painting', 'Google Ads', 8500.00, NULL, 'Office space', 1),

-- Additional records for SecureHome Electric
('SecureHome Electric', 'Diana Diaz', 'ddiaz@email.com', '555-1601', '664 Watt Rd', 'Johns Creek', 'GA', '30097', '2024-02-02', '2024-02-05', '2024-02-07', '2024-02-09', 'Job Completed', 'Light Fixture Install', 'Angi', 450.00, 475.00, 'Chandelier', 1),
('SecureHome Electric', 'Albert Hayes', 'ahayes@email.com', '555-1602', '775 Current Blvd', 'Duluth', 'GA', '30096', '2024-02-04', '2024-02-07', '2024-02-09', '2024-02-16', 'Job Completed', 'GFCI Installation', 'Google Ads', 325.00, 350.00, 'Kitchen outlets', 1),
('SecureHome Electric', 'Brittany Myers', 'bmyers@email.com', '555-1603', '886 Spark Way', 'Lawrenceville', 'GA', '30043', '2024-02-06', '2024-02-09', '2024-02-11', NULL, 'Appointment Sold', 'Smoke Detector', 'Referral', 275.00, NULL, 'Code compliance', 1),
('SecureHome Electric', 'Russell Ford', 'rford@email.com', '555-1604', '997 Charge Ave', 'Decatur', 'GA', '30030', '2024-02-09', '2024-02-12', NULL, NULL, 'Appointment Set', 'Landscape Lighting', 'Facebook', 2800.00, NULL, 'LED system', 1),
('SecureHome Electric', 'Jacqueline Hamilton', 'jhamilton@email.com', '555-1605', '108 Ohm St', 'Kennesaw', 'GA', '30144', '2024-02-11', NULL, NULL, NULL, 'Fresh Lead', 'Hot Tub Wiring', 'Website', 1500.00, NULL, '50 amp circuit', 1),

-- Additional records for CleanAir Duct Services
('CleanAir Duct Services', 'Peter Graham', 'pgraham@email.com', '555-1701', '219 Vent Ln', 'Schaumburg', 'IL', '60193', '2024-02-01', '2024-02-04', '2024-02-06', '2024-02-08', 'Job Completed', 'Vent Installation', 'Google Ads', 550.00, 525.00, 'Bathroom exhaust', 1),
('CleanAir Duct Services', 'Jaclyn Sullivan', 'jsullivan@email.com', '555-1702', '320 Filter Dr', 'Bolingbrook', 'IL', '60440', '2024-02-03', '2024-02-06', '2024-02-08', '2024-02-15', 'Job Completed', 'Filter Replacement', 'Referral', 125.00, 135.00, 'HEPA filters', 1),
('CleanAir Duct Services', 'Keith Wallace', 'kwallace@email.com', '555-1703', '431 Purity Way', 'Wheaton', 'IL', '60187', '2024-02-05', '2024-02-08', '2024-02-10', NULL, 'Appointment Sold', 'Duct Sanitizing', 'Facebook', 450.00, NULL, 'Antimicrobial treatment', 1),
('CleanAir Duct Services', 'Victoria West', 'vwest@email.com', '555-1704', '542 Intake Ave', 'Plainfield', 'IL', '60544', '2024-02-08', '2024-02-11', NULL, NULL, 'Appointment Set', 'Return Air Cleaning', 'Yelp', 275.00, NULL, 'Cold air returns', 1),
('CleanAir Duct Services', 'Juan Brooks', 'jbrooks@email.com', '555-1705', '653 Exhaust St', 'Romeoville', 'IL', '60446', '2024-02-10', NULL, NULL, NULL, 'Fresh Lead', 'Commercial Duct Clean', 'Google Ads', 1800.00, NULL, 'Small office building', 1),

-- Additional records for RestoreIt Water Damage
('RestoreIt Water Damage', 'Danielle Sanders', 'dsanders@email.com', '555-1801', '764 Pump Rd', 'Gresham', 'OR', '97030', '2024-02-02', '2024-02-03', '2024-02-04', '2024-02-08', 'Job Completed', 'Carpet Drying', 'Insurance', 1500.00, 1450.00, 'Pipe burst', 1),
('RestoreIt Water Damage', 'Kyle Price', 'kprice@email.com', '555-1802', '875 Drain Blvd', 'Beaverton', 'OR', '97005', '2024-02-04', '2024-02-05', '2024-02-06', '2024-02-13', 'Job Completed', 'Wall Cavity Dry', 'Plumber Referral', 2200.00, 2150.00, 'Hidden leak', 1),
('RestoreIt Water Damage', 'Rebecca Bennett', 'rbennett@email.com', '555-1803', '986 Rescue Way', 'Lake Oswego', 'OR', '97034', '2024-02-06', '2024-02-07', '2024-02-08', NULL, 'Appointment Sold', 'Content Pack-Out', 'Insurance', 3500.00, NULL, 'Move and store', 1),
('RestoreIt Water Damage', 'Carl Wood', 'cwood@email.com', '555-1804', '197 Save Ave', 'Tigard', 'OR', '97223', '2024-02-09', '2024-02-10', NULL, NULL, 'Appointment Set', 'Odor Removal', 'Referral', 850.00, NULL, 'Smoke smell', 1),
('RestoreIt Water Damage', 'Emma Barnes', 'ebarnes@email.com', '555-1805', '208 Restore St', 'Tualatin', 'OR', '97062', '2024-02-11', NULL, NULL, NULL, 'Fresh Lead', 'Document Drying', 'Insurance', 1200.00, NULL, 'Water damaged files', 1),

-- Additional records for HandyFix Home Repair
('HandyFix Home Repair', 'Roy Ross', 'rross@email.com', '555-1901', '319 Tool Ln', 'Somerville', 'MA', '02143', '2024-02-01', '2024-02-04', '2024-02-06', '2024-02-08', 'Job Completed', 'Trim Installation', 'Google Ads', 950.00, 925.00, 'Crown molding', 1),
('HandyFix Home Repair', 'Christina Henderson', 'chenderson@email.com', '555-1902', '420 Fix Dr', 'Waltham', 'MA', '02451', '2024-02-03', '2024-02-06', '2024-02-08', '2024-02-15', 'Job Completed', 'Baseboard Install', 'Referral', 850.00, 875.00, 'Whole house', 1),
('HandyFix Home Repair', 'Willie Coleman', 'wcoleman@email.com', '555-1903', '531 Build Way', 'Malden', 'MA', '02148', '2024-02-05', '2024-02-08', '2024-02-10', NULL, 'Appointment Sold', 'Closet Shelving', 'Facebook', 650.00, NULL, 'Custom organizer', 1),
('HandyFix Home Repair', 'Tiffany Jenkins', 'tjenkins@email.com', '555-1904', '642 Craft Ave', 'Medford', 'MA', '02155', '2024-02-08', '2024-02-11', NULL, NULL, 'Appointment Set', 'Window Repair', 'Nextdoor', 425.00, NULL, 'Broken seal', 1),
('HandyFix Home Repair', 'Jeremy Perry', 'jperry2@email.com', '555-1905', '753 Nail St', 'Arlington', 'MA', '02474', '2024-02-10', NULL, NULL, NULL, 'Fresh Lead', 'Kitchen Island', 'Houzz', 3500.00, NULL, 'Custom build', 1),

-- Additional records for PowerWash Pros
('PowerWash Pros', 'Shawn Powell', 'spowell@email.com', '555-2001', '864 Rinse Rd', 'Spring Hill', 'TN', '37174', '2024-02-02', '2024-02-05', '2024-02-07', '2024-02-09', 'Job Completed', 'Fence Washing', 'Google Ads', 325.00, 350.00, 'Wood fence', 1),
('PowerWash Pros', 'Vanessa Long', 'vlong@email.com', '555-2002', '975 Jet Blvd', 'Clarksville', 'TN', '37040', '2024-02-04', '2024-02-07', '2024-02-09', '2024-02-16', 'Job Completed', 'Concrete Sealing', 'Referral', 850.00, 825.00, 'Driveway seal', 1),
('PowerWash Pros', 'Christian Hughes', 'chughes@email.com', '555-2003', '186 Stream Way', 'Gallatin', 'TN', '37066', '2024-02-06', '2024-02-09', '2024-02-11', NULL, 'Appointment Sold', 'Brick Cleaning', 'Facebook', 650.00, NULL, 'Front of house', 1),
('PowerWash Pros', 'Megan Flores', 'mflores@email.com', '555-2004', '297 Soak Ave', 'Lebanon', 'TN', '37087', '2024-02-09', '2024-02-12', NULL, NULL, 'Appointment Set', 'Pool Deck Wash', 'Nextdoor', 450.00, NULL, 'Non-slip surface', 1),
('PowerWash Pros', 'Louis Washington', 'lwashington@email.com', '555-2005', '308 Scrub St', 'Smyrna', 'TN', '37167', '2024-02-11', NULL, NULL, NULL, 'Fresh Lead', 'Roof Cleaning', 'Angi', 750.00, NULL, 'Algae removal', 1),

-- More varied records across all brands
('Elite HVAC Solutions', 'Monica Butler', 'mbutler@email.com', '555-2101', '419 Temp Ln', 'Mesa', 'AZ', '85202', '2024-02-12', '2024-02-15', '2024-02-17', '2024-02-23', 'Job Completed', 'Zone Control Install', 'Referral', 3800.00, 3750.00, 'Multi-zone system', 1),
('ProPlumb Masters', 'Austin Simmons', 'asimmons@email.com', '555-2201', '520 Joint Rd', 'Austin', 'TX', '78703', '2024-02-13', '2024-02-16', '2024-02-18', '2024-02-24', 'Job Completed', 'Backflow Testing', 'City Referral', 225.00, 235.00, 'Annual test', 1),
('Sunshine Roofing Co', 'Sara Foster', 'sfoster@email.com', '555-2301', '631 Cover Blvd', 'Miami', 'FL', '33102', '2024-02-14', '2024-02-17', '2024-02-19', NULL, 'Appointment Sold', 'Chimney Flashing', 'Google Ads', 1500.00, NULL, 'Leak repair', 1),
('GreenLawn Landscaping', 'Lucas Gonzales', 'lgonzales@email.com', '555-2401', '742 Grass Way', 'Seattle', 'WA', '98102', '2024-02-15', '2024-02-18', NULL, NULL, 'Appointment Set', 'Fertilization', 'Facebook', 175.00, NULL, 'Four applications', 1),
('PerfectPaint Pro', 'Olivia Bryant', 'obryant@email.com', '555-2501', '853 Stroke Ave', 'Denver', 'CO', '80202', '2024-02-16', NULL, NULL, NULL, 'Fresh Lead', 'Power Washing', 'Referral', 550.00, NULL, 'Prep for painting', 1),
('SecureHome Electric', 'Ethan Alexander', 'ealexander@email.com', '555-2601', '964 Switch St', 'Atlanta', 'GA', '30302', '2024-02-17', '2024-02-20', '2024-02-22', '2024-02-28', 'Job Completed', 'Rewiring', 'Insurance', 5500.00, 5350.00, 'Knob and tube removal', 1),
('CleanAir Duct Services', 'Sophia Russell', 'srussell@email.com', '555-2701', '175 Fresh Ln', 'Chicago', 'IL', '60602', '2024-02-18', '2024-02-21', '2024-02-23', NULL, 'Appointment Sold', 'Coil Cleaning', 'Google Ads', 325.00, NULL, 'AC coil service', 1),
('RestoreIt Water Damage', 'Mason Griffin', 'mgriffin@email.com', '555-2801', '286 Blower Rd', 'Portland', 'OR', '97202', '2024-02-19', '2024-02-20', NULL, NULL, 'Appointment Set', 'Structural Drying', 'Insurance', 4500.00, NULL, 'Severe water damage', 1),
('HandyFix Home Repair', 'Isabella Diaz', 'idiaz@email.com', '555-2901', '397 Screw Blvd', 'Boston', 'MA', '02102', '2024-02-20', NULL, NULL, NULL, 'Fresh Lead', 'Stair Repair', 'Nextdoor', 850.00, NULL, 'Squeaky stairs', 1),
('PowerWash Pros', 'Noah Hayes', 'nhayes@email.com', '555-3001', '408 Nozzle Way', 'Nashville', 'TN', '37202', '2024-02-21', '2024-02-24', '2024-02-26', '2024-03-02', 'Job Completed', 'Commercial Wash', 'Google Ads', 1500.00, 1475.00, 'Storefront cleaning', 1),

('Elite HVAC Solutions', 'Emma Myers', 'emyers@email.com', '555-3101', '519 Chill Ave', 'Phoenix', 'AZ', '85003', '2024-02-22', '2024-02-25', '2024-02-27', NULL, 'Appointment Sold', 'Emergency Repair', 'Emergency Call', 650.00, NULL, 'No cooling at all', 1),
('ProPlumb Masters', 'Liam Ford', 'lford@email.com', '555-3201', '620 Pipe St', 'Austin', 'TX', '78704', '2024-02-23', '2024-02-26', NULL, NULL, 'Appointment Set', 'Gas Line Install', 'Referral', 2800.00, NULL, 'For new range', 1),
('Sunshine Roofing Co', 'Ava Hamilton', 'ahamilton@email.com', '555-3301', '731 Slate Ln', 'Miami', 'FL', '33103', '2024-02-24', NULL, NULL, NULL, 'Fresh Lead', 'Roof Warranty', 'Website', 0.00, NULL, 'Warranty inspection', 1),
('GreenLawn Landscaping', 'William Graham', 'wgraham@email.com', '555-3401', '842 Hedge Rd', 'Seattle', 'WA', '98103', '2024-02-25', '2024-02-28', '2024-03-01', '2024-03-07', 'Job Completed', 'Stump Removal', 'Google Ads', 850.00, 825.00, 'Large oak stump', 1),
('PerfectPaint Pro', 'James Sullivan', 'jsullivan@email.com', '555-3501', '953 Brush Blvd', 'Denver', 'CO', '80203', '2024-02-26', '2024-02-29', '2024-03-02', NULL, 'Appointment Sold', 'Epoxy Coating', 'Referral', 2500.00, NULL, 'Garage floor', 1),
('SecureHome Electric', 'Charlotte Wallace', 'cwallace@email.com', '555-3601', '164 Fuse Way', 'Atlanta', 'GA', '30303', '2024-02-27', '2024-03-01', NULL, NULL, 'Appointment Set', 'Surge Protection', 'Facebook', 950.00, NULL, 'Whole house surge', 1),
('CleanAir Duct Services', 'Benjamin West', 'bwest@email.com', '555-3701', '275 Conduit Ave', 'Chicago', 'IL', '60603', '2024-02-28', NULL, NULL, NULL, 'Fresh Lead', 'Return Vent Add', 'Yelp', 650.00, NULL, 'Additional return', 1),
('RestoreIt Water Damage', 'Amelia Brooks', 'abrooks@email.com', '555-3801', '386 Emergency St', 'Portland', 'OR', '97203', '2024-02-29', '2024-03-01', '2024-03-02', '2024-03-06', 'Job Completed', 'Sewage Mitigation', 'Emergency', 4500.00, 4350.00, 'Main line backup', 1),
('HandyFix Home Repair', 'Henry Sanders', 'hsanders@email.com', '555-3901', '497 Hammer Ln', 'Boston', 'MA', '02103', '2024-03-01', '2024-03-04', '2024-03-06', NULL, 'Appointment Sold', 'Bathroom Vanity', 'Houzz', 1500.00, NULL, 'Vanity installation', 1),
('PowerWash Pros', 'Mia Price', 'mprice@email.com', '555-4001', '508 Spray Rd', 'Nashville', 'TN', '37203', '2024-03-02', '2024-03-05', NULL, NULL, 'Appointment Set', 'Fleet Washing', 'Google Ads', 850.00, NULL, 'Three work trucks', 1),

('Elite HVAC Solutions', 'Alexander Bennett', 'abennett@email.com', '555-4101', '619 Cool Blvd', 'Phoenix', 'AZ', '85004', '2024-03-03', NULL, NULL, NULL, 'Fresh Lead', 'Ductless Split', 'Website', 4200.00, NULL, 'Three zones', 1),
('ProPlumb Masters', 'Evelyn Wood', 'ewood@email.com', '555-4201', '720 Flow Way', 'Austin', 'TX', '78705', '2024-03-04', '2024-03-07', '2024-03-09', '2024-03-15', 'Job Completed', 'Sump Pump Install', 'Referral', 1200.00, 1175.00, 'Basement protection', 1),
('Sunshine Roofing Co', 'Michael Barnes', 'mbarnes2@email.com', '555-4301', '831 Top Ave', 'Miami', 'FL', '33104', '2024-03-05', '2024-03-08', '2024-03-10', NULL, 'Appointment Sold', 'Underlayment Replace', 'Google Ads', 3500.00, NULL, 'Old felt removal', 1),
('GreenLawn Landscaping', 'Abigail Ross', 'aross@email.com', '555-4401', '942 Mow St', 'Seattle', 'WA', '98104', '2024-03-06', '2024-03-09', NULL, NULL, 'Appointment Set', 'Edging Service', 'Facebook', 85.00, NULL, 'Monthly add-on', 1),
('PerfectPaint Pro', 'Daniel Henderson', 'dhenderson@email.com', '555-4501', '153 Finish Ln', 'Denver', 'CO', '80204', '2024-03-07', NULL, NULL, NULL, 'Fresh Lead', 'Stain Removal', 'Nextdoor', 350.00, NULL, 'Water stains', 1),
('SecureHome Electric', 'Emily Coleman', 'ecoleman@email.com', '555-4601', '264 Amp Rd', 'Atlanta', 'GA', '30304', '2024-03-08', '2024-03-11', '2024-03-13', '2024-03-19', 'Job Completed', 'Subpanel Install', 'Referral', 1500.00, 1475.00, 'Detached garage', 1),
('CleanAir Duct Services', 'Matthew Jenkins', 'mjenkins@email.com', '555-4701', '375 Air Blvd', 'Chicago', 'IL', '60604', '2024-03-09', '2024-03-12', '2024-03-14', NULL, 'Appointment Sold', 'Duct Sealing', 'Google Ads', 850.00, NULL, 'Aeroseal process', 1),
('RestoreIt Water Damage', 'Harper Perry', 'hperry@email.com', '555-4801', '486 Wet Way', 'Portland', 'OR', '97204', '2024-03-10', '2024-03-11', NULL, NULL, 'Appointment Set', 'Crawl Space Dry', 'Insurance', 2500.00, NULL, 'Standing water', 1),
('HandyFix Home Repair', 'Jackson Powell', 'jpowell@email.com', '555-4901', '597 Level Ave', 'Boston', 'MA', '02104', '2024-03-11', NULL, NULL, NULL, 'Fresh Lead', 'Countertop Install', 'Angi', 2200.00, NULL, 'Quartz counters', 1),
('PowerWash Pros', 'Ella Long', 'elong@email.com', '555-5001', '608 Clean St', 'Nashville', 'TN', '37204', '2024-03-12', '2024-03-15', '2024-03-17', '2024-03-23', 'Job Completed', 'Sidewalk Cleaning', 'Referral', 325.00, 350.00, 'Moss removal', 1),

-- Additional records to reach 200+ total
('Elite HVAC Solutions', 'Sophia Davis', 'sdavis@email.com', '555-5101', '719 Breeze Ln', 'Phoenix', 'AZ', '85005', '2024-03-13', '2024-03-16', '2024-03-18', NULL, 'Appointment Sold', 'AC Repair', 'Google Ads', 550.00, NULL, 'Refrigerant leak', 1),
('ProPlumb Masters', 'Logan Miller', 'lmiller@email.com', '555-5201', '820 Drain Dr', 'Austin', 'TX', '78706', '2024-03-14', '2024-03-17', NULL, NULL, 'Appointment Set', 'Water Line Replace', 'Referral', 3500.00, NULL, 'Galvanized pipes', 1),
('Sunshine Roofing Co', 'Grace Wilson', 'gwilson@email.com', '555-5301', '931 Roof Rd', 'Miami', 'FL', '33105', '2024-03-15', NULL, NULL, NULL, 'Fresh Lead', 'Shingle Repair', 'Website', 850.00, NULL, 'Wind damage', 1),
('GreenLawn Landscaping', 'Jackson Moore', 'jmoore@email.com', '555-5401', '142 Plant Way', 'Seattle', 'WA', '98105', '2024-03-16', '2024-03-19', '2024-03-21', '2024-03-27', 'Job Completed', 'Bush Removal', 'Facebook', 650.00, 625.00, 'Three large bushes', 1),
('PerfectPaint Pro', 'Chloe Taylor', 'ctaylor@email.com', '555-5501', '253 Tone Ave', 'Denver', 'CO', '80205', '2024-03-17', '2024-03-20', '2024-03-22', NULL, 'Appointment Sold', 'Accent Wall', 'Houzz', 450.00, NULL, 'Feature wall paint', 1),
('SecureHome Electric', 'Carter Anderson', 'canderson@email.com', '555-5601', '364 Volt St', 'Atlanta', 'GA', '30305', '2024-03-18', '2024-03-21', NULL, NULL, 'Appointment Set', 'Smart Home Wiring', 'Referral', 2200.00, NULL, 'Home automation', 1),
('CleanAir Duct Services', 'Lily Thomas', 'lthomas@email.com', '555-5701', '475 Vent Ln', 'Chicago', 'IL', '60605', '2024-03-19', NULL, NULL, NULL, 'Fresh Lead', 'Furnace Cleaning', 'Google Ads', 425.00, NULL, 'Annual service', 1),
('RestoreIt Water Damage', 'Wyatt Jackson', 'wjackson@email.com', '555-5801', '586 Dry Blvd', 'Portland', 'OR', '97205', '2024-03-20', '2024-03-21', '2024-03-22', '2024-03-26', 'Job Completed', 'Attic Water Damage', 'Insurance', 3200.00, 3150.00, 'Roof leak damage', 1),
('HandyFix Home Repair', 'Aria White', 'awhite2@email.com', '555-5901', '697 Build Way', 'Boston', 'MA', '02105', '2024-03-21', '2024-03-24', '2024-03-26', NULL, 'Appointment Sold', 'Shelving Install', 'Nextdoor', 550.00, NULL, 'Garage organization', 1),
('PowerWash Pros', 'Elijah Harris', 'eharris@email.com', '555-6001', '708 Wash Rd', 'Nashville', 'TN', '37205', '2024-03-22', '2024-03-25', NULL, NULL, 'Appointment Set', 'Window Cleaning', 'Facebook', 275.00, NULL, 'Exterior windows', 1),

('Elite HVAC Solutions', 'Zoe Martin', 'zmartin@email.com', '555-6101', '819 Temp Dr', 'Scottsdale', 'AZ', '85252', '2024-03-23', NULL, NULL, NULL, 'Fresh Lead', 'Thermostat Repair', 'Angi', 225.00, NULL, 'Not working', 1),
('ProPlumb Masters', 'Lincoln Thompson', 'lthompson@email.com', '555-6201', '920 Valve Ave', 'Round Rock', 'TX', '78665', '2024-03-24', '2024-03-27', '2024-03-29', '2024-04-04', 'Job Completed', 'Pressure Reducer', 'Google Ads', 850.00, 825.00, 'High water pressure', 1),
('Sunshine Roofing Co', 'Layla Garcia', 'lgarcia@email.com', '555-6301', '131 Peak St', 'Fort Lauderdale', 'FL', '33302', '2024-03-25', '2024-03-28', '2024-03-30', NULL, 'Appointment Sold', 'Valley Flashing', 'Referral', 1500.00, NULL, 'Valley leak repair', 1),
('GreenLawn Landscaping', 'Grayson Martinez', 'gmartinez@email.com', '555-6401', '242 Soil Ln', 'Tacoma', 'WA', '98402', '2024-03-26', '2024-03-29', NULL, NULL, 'Appointment Set', 'Soil Testing', 'Website', 150.00, NULL, 'pH and nutrients', 1),
('PerfectPaint Pro', 'Penelope Robinson', 'probinson@email.com', '555-6501', '353 Hue Rd', 'Arvada', 'CO', '80003', '2024-03-27', NULL, NULL, NULL, 'Fresh Lead', 'Color Consultation', 'Houzz', 200.00, NULL, 'Whole house colors', 1),
('SecureHome Electric', 'Jack Clark', 'jclark@email.com', '555-6601', '464 Power Blvd', 'Roswell', 'GA', '30076', '2024-03-28', '2024-03-31', '2024-04-02', '2024-04-08', 'Job Completed', 'Recessed Lighting', 'Google Ads', 1850.00, 1800.00, 'Kitchen remodel', 1),
('CleanAir Duct Services', 'Scarlett Rodriguez', 'srodriguez@email.com', '555-6701', '575 Clean Way', 'Naperville', 'IL', '60541', '2024-03-29', '2024-04-01', '2024-04-03', NULL, 'Appointment Sold', 'Duct Inspection', 'Referral', 225.00, NULL, 'Camera inspection', 1),
('RestoreIt Water Damage', 'Leo Lewis', 'llewis@email.com', '555-6801', '686 Fix Ave', 'Eugene', 'OR', '97402', '2024-03-30', '2024-03-31', NULL, NULL, 'Appointment Set', 'Biohazard Cleanup', 'Insurance', 5500.00, NULL, 'Sewage contamination', 1),
('HandyFix Home Repair', 'Riley Lee', 'rlee@email.com', '555-6901', '797 Repair St', 'Cambridge', 'MA', '02139', '2024-03-31', NULL, NULL, NULL, 'Fresh Lead', 'Flooring Install', 'Angi', 4500.00, NULL, 'Luxury vinyl plank', 1),
('PowerWash Pros', 'Hannah Walker', 'hwalker@email.com', '555-7001', '808 Spray Ln', 'Franklin', 'TN', '37065', '2024-04-01', '2024-04-04', '2024-04-06', '2024-04-12', 'Job Completed', 'Awning Cleaning', 'Google Ads', 225.00, 245.00, 'Fabric awnings', 1),

('Elite HVAC Solutions', 'Nora Hall', 'nhall@email.com', '555-7101', '919 Cool Dr', 'Mesa', 'AZ', '85203', '2024-04-02', '2024-04-05', '2024-04-07', NULL, 'Appointment Sold', 'Filter Change', 'Website', 125.00, NULL, 'Premium filters', 1),
('ProPlumb Masters', 'Maverick Allen', 'mallen@email.com', '555-7201', '120 Flow Rd', 'Georgetown', 'TX', '78627', '2024-04-03', '2024-04-06', NULL, NULL, 'Appointment Set', 'Shower Pan Repair', 'Referral', 1800.00, NULL, 'Leaking shower', 1),
('Sunshine Roofing Co', 'Hazel Young', 'hyoung@email.com', '555-7301', '231 Shingle Blvd', 'Boca Raton', 'FL', '33432', '2024-04-04', NULL, NULL, NULL, 'Fresh Lead', 'Impact Windows', 'Facebook', 12000.00, NULL, 'Hurricane protection', 1),
('GreenLawn Landscaping', 'Jaxon Hernandez', 'jhernandez@email.com', '555-7401', '342 Green Way', 'Redmond', 'WA', '98053', '2024-04-05', '2024-04-08', '2024-04-10', '2024-04-16', 'Job Completed', 'Moss Control', 'Google Ads', 350.00, 375.00, 'Lawn treatment', 1),
('PerfectPaint Pro', 'Violet King', 'vking@email.com', '555-7501', '453 Canvas Ave', 'Westminster', 'CO', '80031', '2024-04-06', '2024-04-09', '2024-04-11', NULL, 'Appointment Sold', 'Door Refinishing', 'Referral', 750.00, NULL, 'Front door staining', 1),
('SecureHome Electric', 'Owen Wright', 'owright@email.com', '555-7601', '564 Circuit St', 'Marietta', 'GA', '30061', '2024-04-07', '2024-04-10', NULL, NULL, 'Appointment Set', 'Security System', 'Website', 2500.00, NULL, 'Hardwired system', 1),
('CleanAir Duct Services', 'Aurora Lopez', 'alopez@email.com', '555-7701', '675 Air Ln', 'Aurora', 'IL', '60506', '2024-04-08', NULL, NULL, NULL, 'Fresh Lead', 'Carbon Monoxide Test', 'Yelp', 175.00, NULL, 'Safety inspection', 1),
('RestoreIt Water Damage', 'Asher Hill', 'ahill@email.com', '555-7801', '786 Wet Rd', 'Salem', 'OR', '97302', '2024-04-09', '2024-04-10', '2024-04-11', '2024-04-15', 'Job Completed', 'Ceiling Dry Out', 'Insurance', 2800.00, 2750.00, 'Upstairs leak', 1),
('HandyFix Home Repair', 'Bella Scott', 'bscott@email.com', '555-7901', '897 Tool Blvd', 'Quincy', 'MA', '02170', '2024-04-10', '2024-04-13', '2024-04-15', NULL, 'Appointment Sold', 'Ceiling Fan Balance', 'Nextdoor', 175.00, NULL, 'Wobbling fan', 1),
('PowerWash Pros', 'Lincoln Green', 'lgreen@email.com', '555-8001', '908 Clean Way', 'Murfreesboro', 'TN', '37131', '2024-04-11', '2024-04-14', NULL, NULL, 'Appointment Set', 'Tennis Court Clean', 'Angi', 950.00, NULL, 'Court resurfacing prep', 1),

('Elite HVAC Solutions', 'Savannah Adams', 'sadams@email.com', '555-8101', '119 Air Ave', 'Gilbert', 'AZ', '85296', '2024-04-12', NULL, NULL, NULL, 'Fresh Lead', 'Condenser Cleaning', 'Google Ads', 225.00, NULL, 'Coil cleaning', 1),
('ProPlumb Masters', 'Elias Baker', 'ebaker@email.com', '555-8201', '220 Pipe St', 'Cedar Park', 'TX', '78614', '2024-04-13', '2024-04-16', '2024-04-18', '2024-04-24', 'Job Completed', 'Tankless Water Heater', 'Referral', 3500.00, 3400.00, 'Energy efficient', 1),
('Sunshine Roofing Co', 'Brooklyn Gonzalez', 'bgonzalez@email.com', '555-8301', '331 Cover Ln', 'West Palm Beach', 'FL', '33402', '2024-04-14', '2024-04-17', '2024-04-19', NULL, 'Appointment Sold', 'Vent Boot Replace', 'Google Ads', 650.00, NULL, 'Pipe boot repair', 1),
('GreenLawn Landscaping', 'Easton Nelson', 'enelson@email.com', '555-8401', '442 Lawn Rd', 'Kirkland', 'WA', '98034', '2024-04-15', '2024-04-18', NULL, NULL, 'Appointment Set', 'Weed Control', 'Facebook', 195.00, NULL, 'Pre-emergent treatment', 1),
('PerfectPaint Pro', 'Claire Carter', 'ccarter2@email.com', '555-8501', '553 Palette Blvd', 'Lakewood', 'CO', '80227', '2024-04-16', NULL, NULL, NULL, 'Fresh Lead', 'Touch-Up Service', 'Website', 350.00, NULL, 'Walls and trim', 1),
('SecureHome Electric', 'Levi Mitchell', 'lmitchell@email.com', '555-8601', '664 Watt Way', 'Alpharetta', 'GA', '30005', '2024-04-17', '2024-04-20', '2024-04-22', '2024-04-28', 'Job Completed', 'Pool Equipment Wire', 'Referral', 1200.00, 1175.00, 'Pool pump wiring', 1),
('CleanAir Duct Services', 'Stella Perez', 'sperez@email.com', '555-8701', '775 Flow Ave', 'Joliet', 'IL', '60436', '2024-04-18', '2024-04-21', '2024-04-23', NULL, 'Appointment Sold', 'Register Cleaning', 'Google Ads', 175.00, NULL, 'Vent register detail', 1),
('RestoreIt Water Damage', 'Hudson Roberts', 'hroberts@email.com', '555-8801', '886 Save St', 'Bend', 'OR', '97702', '2024-04-19', '2024-04-20', NULL, NULL, 'Appointment Set', 'Pack and Move', 'Insurance', 2500.00, NULL, 'Contents relocation', 1),
('HandyFix Home Repair', 'Paisley Turner', 'pturner@email.com', '555-8901', '997 Fix Ln', 'Newton', 'MA', '02459', '2024-04-20', NULL, NULL, NULL, 'Fresh Lead', 'Backsplash Install', 'Houzz', 1800.00, NULL, 'Tile backsplash', 1),
('PowerWash Pros', 'Colton Phillips', 'cphillips@email.com', '555-9001', '108 Pressure Rd', 'Hendersonville', 'TN', '37076', '2024-04-21', '2024-04-24', '2024-04-26', '2024-05-02', 'Job Completed', 'RV Washing', 'Referral', 450.00, 475.00, 'Full RV exterior', 1),

('Elite HVAC Solutions', 'Skylar Campbell', 'scampbell@email.com', '555-9101', '219 Climate Blvd', 'Chandler', 'AZ', '85225', '2024-04-22', '2024-04-25', '2024-04-27', NULL, 'Appointment Sold', 'Compressor Replace', 'Google Ads', 2800.00, NULL, 'Failed compressor', 1),
('ProPlumb Masters', 'Micah Parker', 'mparker@email.com', '555-9201', '320 Drain Way', 'Pflugerville', 'TX', '78661', '2024-04-23', '2024-04-26', NULL, NULL, 'Appointment Set', 'Camera Inspection', 'Website', 350.00, NULL, 'Line inspection', 1),
('Sunshine Roofing Co', 'Luna Evans', 'levans@email.com', '555-9301', '431 Ridge Ave', 'Delray Beach', 'FL', '33445', '2024-04-24', NULL, NULL, NULL, 'Fresh Lead', 'Attic Ventilation', 'Facebook', 1800.00, NULL, 'Add roof vents', 1),
('GreenLawn Landscaping', 'Silas Edwards', 'sedwards@email.com', '555-9401', '542 Flower St', 'Bellevue', 'WA', '98005', '2024-04-25', '2024-04-28', '2024-04-30', '2024-05-06', 'Job Completed', 'Spring Cleanup', 'Google Ads', 650.00, 625.00, 'Seasonal service', 1),
('PerfectPaint Pro', 'Ellie Collins', 'ecollins@email.com', '555-9501', '653 Finish Ln', 'Denver', 'CO', '80206', '2024-04-26', '2024-04-29', '2024-05-01', NULL, 'Appointment Sold', 'Textured Ceiling', 'Referral', 1500.00, NULL, 'Knockdown texture', 1),
('SecureHome Electric', 'Dominic Stewart', 'dstewart@email.com', '555-9601', '764 Amp Rd', 'Sandy Springs', 'GA', '30329', '2024-04-27', '2024-04-30', NULL, NULL, 'Appointment Set', 'Under Cabinet Light', 'Nextdoor', 850.00, NULL, 'Kitchen LED strips', 1),
('CleanAir Duct Services', 'Lucy Morris', 'lmorris@email.com', '555-9701', '875 Breath Blvd', 'Elgin', 'IL', '60121', '2024-04-28', NULL, NULL, NULL, 'Fresh Lead', 'Allergen Treatment', 'Yelp', 450.00, NULL, 'Allergy season prep', 1),
('RestoreIt Water Damage', 'Isaiah Rogers', 'irogers@email.com', '555-9801', '986 Restore Way', 'Hillsboro', 'OR', '97124', '2024-04-29', '2024-04-30', '2024-05-01', '2024-05-05', 'Job Completed', 'Hardwood Drying', 'Insurance', 3500.00, 3400.00, 'Buckled floors', 1),
('HandyFix Home Repair', 'Aaliyah Reed', 'areed@email.com', '555-9901', '197 Maintain Ave', 'Brookline', 'MA', '02446', '2024-04-30', '2024-05-03', '2024-05-05', NULL, 'Appointment Sold', 'Light Fixture', 'Google Ads', 425.00, NULL, 'Bathroom vanity light', 1),
('PowerWash Pros', 'Axel Cook', 'acook@email.com', '555-0010', '208 Wash St', 'Nashville', 'TN', '37206', '2024-05-01', '2024-05-04', NULL, NULL, 'Appointment Set', 'Siding Soft Wash', 'Referral', 550.00, NULL, 'Gentle cleaning', 1),

('Elite HVAC Solutions', 'Madelyn Morgan', 'mmorgan@email.com', '555-0110', '319 Fresh Ln', 'Peoria', 'AZ', '85346', '2024-05-02', NULL, NULL, NULL, 'Fresh Lead', 'Duct Insulation', 'Angi', 2200.00, NULL, 'Attic duct wrap', 1),
('ProPlumb Masters', 'Cooper Bell', 'cbell@email.com', '555-0210', '420 Water Rd', 'Leander', 'TX', '78642', '2024-05-03', '2024-05-06', '2024-05-08', '2024-05-14', 'Job Completed', 'Dishwasher Install', 'Google Ads', 350.00, 375.00, 'New appliance hookup', 1),
('Sunshine Roofing Co', 'Kinsley Murphy', 'kmurphy@email.com', '555-0310', '531 Drip Blvd', 'Pompano Beach', 'FL', '33061', '2024-05-04', '2024-05-07', '2024-05-09', NULL, 'Appointment Sold', 'Drip Edge Install', 'Referral', 1200.00, NULL, 'Edge protection', 1),
('GreenLawn Landscaping', 'Weston Bailey', 'wbailey@email.com', '555-0410', '642 Grow Way', 'Federal Way', 'WA', '98004', '2024-05-05', '2024-05-08', NULL, NULL, 'Appointment Set', 'Seed Overseeding', 'Facebook', 450.00, NULL, 'Thicken lawn', 1),
('PerfectPaint Pro', 'Naomi Rivera', 'nrivera@email.com', '555-0510', '753 Color Ave', 'Castle Rock', 'CO', '80105', '2024-05-06', NULL, NULL, NULL, 'Fresh Lead', 'Sealant Application', 'Website', 650.00, NULL, 'Wood protection', 1),
('SecureHome Electric', 'Caleb Cooper', 'ccooper@email.com', '555-0610', '864 Current St', 'Johns Creek', 'GA', '30098', '2024-05-07', '2024-05-10', '2024-05-12', '2024-05-18', 'Job Completed', 'Outdoor Receptacle', 'Google Ads', 425.00, 450.00, 'GFCI outlets', 1),
('CleanAir Duct Services', 'Genesis Richardson', 'grichardson@email.com', '555-0710', '975 Pure Ln', 'Schaumburg', 'IL', '60194', '2024-05-08', '2024-05-11', '2024-05-13', NULL, 'Appointment Sold', 'Blower Motor Clean', 'Referral', 275.00, NULL, 'Furnace blower', 1),
('RestoreIt Water Damage', 'Jameson Cox', 'jcox@email.com', '555-0810', '186 Relief Rd', 'Gresham', 'OR', '97031', '2024-05-09', '2024-05-10', NULL, NULL, 'Appointment Set', 'Debris Removal', 'Insurance', 1800.00, NULL, 'Storm damage debris', 1),
('HandyFix Home Repair', 'Elena Howard', 'ehoward@email.com', '555-0910', '297 Build Blvd', 'Somerville', 'MA', '02144', '2024-05-10', NULL, NULL, NULL, 'Fresh Lead', 'Crown Molding', 'Houzz', 1200.00, NULL, 'Living room trim', 1),
('PowerWash Pros', 'Sawyer Ward', 'sward@email.com', '555-1010', '308 Jet Way', 'Spring Hill', 'TN', '37175', '2024-05-11', '2024-05-14', '2024-05-16', '2024-05-22', 'Job Completed', 'Garage Floor', 'Google Ads', 375.00, 395.00, 'Epoxy prep wash', 1),

('Elite HVAC Solutions', 'Maya Cox', 'mcox2@email.com', '555-1110', '419 Comfort Ave', 'Surprise', 'AZ', '85375', '2024-05-12', '2024-05-15', '2024-05-17', NULL, 'Appointment Sold', 'Blower Wheel Clean', 'Referral', 325.00, NULL, 'Efficiency service', 1),
('ProPlumb Masters', 'Ezra Diaz', 'ediaz@email.com', '555-1210', '520 Valve St', 'Kyle', 'TX', '78641', '2024-05-13', '2024-05-16', NULL, NULL, 'Appointment Set', 'Angle Stop Replace', 'Facebook', 275.00, NULL, 'Leaking shutoff', 1),
('Sunshine Roofing Co', 'Piper Richardson', 'prichardson@email.com', '555-1310', '631 Cap Ln', 'Boynton Beach', 'FL', '33436', '2024-05-14', NULL, NULL, NULL, 'Fresh Lead', 'Ridge Cap Repair', 'Google Ads', 950.00, NULL, 'Missing caps', 1),
('GreenLawn Landscaping', 'Josiah Wood', 'jwood@email.com', '555-1410', '742 Trim Rd', 'Kent', 'WA', '98031', '2024-05-15', '2024-05-18', '2024-05-20', '2024-05-26', 'Job Completed', 'Privacy Screening', 'Yelp', 2500.00, 2450.00, 'Arborvitae hedge', 1),
('PerfectPaint Pro', 'Kennedy Barnes', 'kbarnes@email.com', '555-1510', '853 Layer Blvd', 'Thornton', 'CO', '80230', '2024-05-16', '2024-05-19', '2024-05-21', NULL, 'Appointment Sold', 'Metal Fence Paint', 'Referral', 1100.00, NULL, 'Wrought iron fence', 1),
('SecureHome Electric', 'Everett Henderson', 'ehenderson@email.com', '555-1610', '964 Line Way', 'Duluth', 'GA', '30097', '2024-05-17', '2024-05-20', NULL, NULL, 'Appointment Set', 'Transfer Switch', 'Website', 1500.00, NULL, 'Generator hookup', 1),
('CleanAir Duct Services', 'Quinn Coleman', 'qcoleman@email.com', '555-1710', '175 Intake Ave', 'Bolingbrook', 'IL', '60441', '2024-05-18', NULL, NULL, NULL, 'Fresh Lead', 'Static Pressure Test', 'Google Ads', 225.00, NULL, 'System diagnostic', 1),
('RestoreIt Water Damage', 'Roman Jenkins', 'rjenkins@email.com', '555-1810', '286 Repair St', 'Beaverton', 'OR', '97006', '2024-05-19', '2024-05-20', '2024-05-21', '2024-05-25', 'Job Completed', 'Dishwasher Flood', 'Emergency', 1500.00, 1475.00, 'Leak cleanup', 1),
('HandyFix Home Repair', 'Emery Perry', 'eperry@email.com', '555-1910', '397 Craft Ln', 'Waltham', 'MA', '02452', '2024-05-20', '2024-05-23', '2024-05-25', NULL, 'Appointment Sold', 'Weatherstripping', 'Nextdoor', 350.00, NULL, 'Door and window seals', 1),
('PowerWash Pros', 'Rowan Powell', 'rpowell@email.com', '555-2010', '408 Flow Rd', 'Clarksville', 'TN', '37041', '2024-05-21', '2024-05-24', NULL, NULL, 'Appointment Set', 'Storefront Maintenance', 'Angi', 650.00, NULL, 'Monthly service', 1);

-- Create index for better query performance
CREATE INDEX idx_brand_name ON customer_journey(brand_name);
CREATE INDEX idx_journey_stage ON customer_journey(journey_stage);
CREATE INDEX idx_lead_date ON customer_journey(lead_date);
CREATE INDEX idx_active ON customer_journey(active);

-- Display summary statistics
SELECT 
    brand_name,
    COUNT(*) as total_records,
    SUM(CASE WHEN journey_stage = 'Fresh Lead' THEN 1 ELSE 0 END) as fresh_leads,
    SUM(CASE WHEN journey_stage = 'Appointment Set' THEN 1 ELSE 0 END) as appointments_set,
    SUM(CASE WHEN journey_stage = 'Appointment Sold' THEN 1 ELSE 0 END) as appointments_sold,
    SUM(CASE WHEN journey_stage = 'Job Completed' THEN 1 ELSE 0 END) as jobs_completed
FROM customer_journey
GROUP BY brand_name
ORDER BY brand_name;

SELECT 'Database setup complete! 200 records created across 10 home service brands.' as status;

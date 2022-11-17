SELECT policy.policy_number, feature.name 
  FROM policy 
  JOIN type_coverage ON type_coverage.policy_type_id = policy.policy_type_id
  JOIN type_coverage_feature ON type_coverage.id = type_coverage_feature.type_coverage_type_coverage_id
  JOIN feature ON type_coverage_feature.feature_feature_id = feature.id
  AND feature.id = 2;
 
SELECT feature.feature_name FROM feature 
  JOIN feature_coverage ON feature_coverage.feature_id = feature.feature_id
  JOIN coverage ON feature_coverage.coverage_id = coverage.coverage_id
  WHERE coverage.coverage_id = 3;

SELECT feature.feature_name from feature
  JOIN coverageGroup ON feature.coveragegroup_id = coveragegroup.coveragegroup_id
  WHERE coveragegroup.coveragegroup_name = 'Samochod';
  
SELECT insurance.insurance_number, coverage.coverage_name FROM insurance 
  JOIN coverage ON coverage.coverage_id = insurance.coverage_id
  WHERE coverage.coveragegroup_id = 1;
  
SELECT insurance.insurance_number FROM insurance 
  JOIN coverage ON coverage.coverage_id = insurance.coverage_id
  JOIN coveragegroup ON coveragegroup.coveragegroup_id = coverage.coveragegroup_id
  WHERE coveragegroup.coveragegroup_name = 'Dom';
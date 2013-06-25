UPDATE colfusion_relationships_columns set cl_from=concat('cid(', cl_from, ')')
WHERE cl_from REGEXP  '^[0-9]+$';
UPDATE colfusion_relationships_columns set cl_to=concat('cid(', cl_to, ')')
WHERE cl_to REGEXP  '^[0-9]+$';
function plan = buildfile
import matlab.buildtool.tasks.*

plan = buildplan(localfunctions);

% Open project if it is not open
if isempty(matlab.project.rootProject)
    openProject(plan.RootFolder);
end

% Set default task
plan.DefaultTasks = "test";

% Create shorthand for files/folders
codeFiles = fullfile("toolbox","*");
testFiles = fullfile("tests","*");
tbxPackagingFiles = fullfile("Example_ToolboxOptionsObject","*");
tbxOutputFile = pokerHandsToolboxDefinition().OutputFile;


% Configure tasks

% plan("check") = CodeIssuesTask();

plan("test") = TestTask(testFiles, ...
    SourceFiles = codeFiles, ...
    IncludeSubfolders = true);
% plan("test").Dependencies = "check";

plan("toolbox").Inputs = [codeFiles,tbxPackagingFiles];
plan("toolbox").Outputs = tbxOutputFile;
plan("toolbox").Dependencies = "test";
% plan("toolbox").Dependencies = ["check","test"];

plan("clean") = CleanTask();

end


%% Tasks

function toolboxTask(~)
% Package toolbox
packageMyToolbox();
end


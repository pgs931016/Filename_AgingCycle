% 1번 save_path 설정
clc; 
clear; 
close all;

slash = filesep;

% load xlxs
Data_path = '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL_Data2/HNE_AgingDOE_mat';



% Data_path를 슬래시 기준으로 분리
splitPath = split(Data_path, filesep);

% "Data"가 포함된 인덱스를 찾음
index1 = find(strcmp('HNE_AgingDOE_mat', splitPath), 1);

% "Data"를 "Processed_Data"로 변경 (요구사항에 따라)
splitPath{index1} = 'HNE_AgingDOE_Processed';

% index까지의 경로만을 사용하여 save_path 설정
savePathComponents = splitPath(1:index1);

% save_path를 재구성
save_path = strjoin(savePathComponents, filesep);


% 엑셀 Data load
xlsfile = '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL_Data2/HNE_Folder_Automation.xlsx';

if exist(xlsfile, 'file') == 2
    disp('File exists.');
else
    disp('File does not exist.');
end


% 각 시트를 읽어오기 위해 엑셀 파일의 정보를 가져옵니다.
sheetNames = sheetnames(xlsfile);
disp(class(sheetNames));  % sheetNames의 데이터 타입 출력




% 찾고자 하는 문자열
desiredString = 'RPT1';


% 입력한 문자열과 일치하는 시트를 찾아서 데이터를 적용
for i = 1:length(sheetNames)
    % 엑셀 파일에서 데이터를 읽어와 테이블로 변환
    data = readtable(xlsfile, 'Sheet', sheetNames(i));


    % 시트 헤더 가져오기
    sheetHeaders = data.Properties.VariableNames;

    % 입력한 문자열과 시트의 7번째 열의 1행의 문자가 일치하면 데이터 적용
    if strcmp(data.(sheetHeaders{7})(1), desiredString)
        % 시트의 첫 번째 열의 값
        firstColumnData = data.(sheetHeaders{7});
        firstColumnData(cellfun(@(x) isequal(x, 'None') || isempty(x), firstColumnData)) = [];
        uniqueFirstValues = unique(firstColumnData);
        uniqueFirstValues = uniqueFirstValues(~cellfun('isempty', uniqueFirstValues));

        % 두 번째 셀의 첫 번째 값
        secondColumnData = data.(sheetHeaders{2});
        secondColumnData(cellfun(@(x) isequal(x, 'None') || isempty(x), secondColumnData)) = [];
        uniqueSecondValues = unique(secondColumnData);
        uniqueSecondValues = uniqueSecondValues(~cellfun('isempty', uniqueSecondValues));

        % 세 번째 셀의 첫 번째 값
        thirdColumnData = data.(sheetHeaders{3});
        thirdColumnData(cellfun(@(x) isequal(x, 'None') || isempty(x), thirdColumnData)) = [];
        uniqueThirdValues = unique(thirdColumnData);
        uniqueThirdValues = uniqueThirdValues(~cellfun('isempty', uniqueThirdValues));

        % 네 번째 셀의 첫 번째 값
        fourthColumnData = data.(sheetHeaders{4});
        fourthColumnData(cellfun(@(x) isequal(x, 'None') || isempty(x), fourthColumnData)) = [];
        uniqueFourthValues = unique(fourthColumnData);
        uniqueFourthValues = uniqueFourthValues(~cellfun('isempty', uniqueFourthValues));

        % 다섯 번째 셀의 첫 번째 값
        fifthColumnData = data.(sheetHeaders{1});
        fifthColumnData(cellfun(@(x) isequal(x, 'None') || isempty(x), fifthColumnData)) = [];
        uniqueFifthValues = unique(fifthColumnData);
        uniqueFifthValues = uniqueFifthValues(~cellfun('isempty', uniqueFifthValues));

        % 여섯 번째 셀의 첫 번째 값
        sixthColumnData = data.(sheetHeaders{5});
        sixthColumnData = sixthColumnData(~isnan(sixthColumnData));
        uniqueSixthValues = unique(sixthColumnData);

        % 일곱 번째 셀의 첫 번째 값을 
        seventhColumnData = data.(sheetHeaders{6});
        seventhColumnData = seventhColumnData(~isnan(seventhColumnData));
        uniqueSeventhValues = unique(seventhColumnData);




        %폴더 생성
        for i = 1:length(uniqueFirstValues)
            folderPath1 = fullfile(save_path, uniqueFifthValues{i});
            % if ~exist(folderPath1, 'dir')
            %     mkdir(folderPath1);
            %end
            for i = 1:length(uniqueFirstValues)
            folderPath2 = fullfile(save_path, uniqueFirstValues{i});
            % if ~exist(folderPath2, 'dir')
            %     mkdir(folderPath2);
            % end

                for j = 1:length(uniqueSecondValues)
                folderPath3 = fullfile(folderPath2, uniqueSecondValues{j});
                % if ~exist(folderPath3, 'dir')
                %     mkdir(folderPath3);
                % end

                 for k = 1:length(uniqueThirdValues)
                    folderPath4 = fullfile(folderPath3, uniqueThirdValues{k});
                    % if ~exist(folderPath4, 'dir')
                    %     mkdir(folderPath4);
                    % end
                end
            end
        end
        break; % 일치하는 시트를 찾았으므로 루프 중단
    end
end
end


% RPT1 폴더 내의 파일들을 가져와서 처리

alltxtfiles = {};
subfolders = dir(Data_path);
subfolders = subfolders([subfolders.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));

% desiredString과 일치하는 폴더 찾기
for i = 1:length(subfolders)
    if strcmp(subfolders(i).name, desiredString)
        % 일치하는 폴더 내의 .txt 파일 찾기
        targetfolderPath = fullfile(Data_path, subfolders(i).name);
        txtfiles = dir(fullfile(targetfolderPath, '*.mat'));

        % 각 파일의 전체 경로를 alltxtfiles에 추가
        for j = 1:length(txtfiles)
            alltxtfiles{end+1} = fullfile(targetfolderPath, txtfiles(j).name);
        end
    end
end



for i = 1:length(alltxtfiles)
    currentFile = alltxtfiles{i};
    [~, fileName, fileExt] = fileparts(currentFile);

    % 언더스코어(_)로 파일 이름을 분리
    fileName = strrep(fileName, '_DC', ''); % 파일 이름에서 '_DC' 제거
    parts = strsplit(fileName, '_');

    if length(parts) >= 2
        numPart = str2double(parts{end}); 

        for idx = 1:length(sixthColumnData)

                % sheetHeaders{5}와 numPart가 일치하는 경우
                if any(sixthColumnData == numPart)
                    % numPart와 일치하는 인덱스 찾기
                    numidx = find(sixthColumnData == numPart);

                    % sheetHeaders{2}와 sheetHeaders{3}에 폴더 분배
                    for k = 1:length(numidx)
                        idxToUse = numidx(k);
                        firstValue = data.(sheetHeaders{1}){idxToUse};
                        secondValue = data.(sheetHeaders{2}){idxToUse};
                        thirdValue = data.(sheetHeaders{3}){idxToUse};
                        fourthValue = data.(sheetHeaders{4}){idxToUse};
                        fifthValue = data.(sheetHeaders{5})(idxToUse);
                        sixthValue = data.(sheetHeaders{6})(idxToUse);
                        seventhValue = data.(sheetHeaders{7}){idxToUse};


                        folderPath1 = fullfile(save_path, firstValue);
                        folderPath2 = fullfile(folderPath1, seventhValue);
                        folderPath3 = fullfile(folderPath2, secondValue);
                        folderPath4 = fullfile(folderPath3, thirdValue);


                     % 새로운 파일 이름 구성
                    if floor(fifthValue) == fifthValue && floor(sixthValue) == sixthValue
                     % 정수인 경우
                     newFileName = sprintf('%s_%s_%s_%s_%d_%d_%s%s', firstValue, secondValue, thirdValue, fourthValue, fifthValue, sixthValue, seventhValue,  fileExt);
                    else
                     % 소수점이 포함된 경우
                     newFileName = sprintf('%s_%s_%s_%s_%.2f_%.2f_%s%s', firstValue, secondValue, thirdValue, fourthValue, fifthValue, sixthValue, seventhValue,  fileExt);
                    end

                    if ~exist(folderPath4, 'dir')
                            mkdir(folderPath4);

                    end

                        % 새 파일 경로 생성
                        newFilePath = fullfile(folderPath4, newFileName);

                        % 원본 파일을 새 경로로 복사
                        copyfile(currentFile, newFilePath);

                    end
                end
            end
        end
end


% % 디렉토리 경로 설정
% dirPath = {
%     '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL_Data2/HNE_AgingDOE_processed/HNE_FCC/RPT1/25C/4CPD 1C (25-42)',
%     '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL_Data2/HNE_AgingDOE_processed/HNE_FCC/Aging1/4CPD 1C (25-42)',
%     '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL_Data2/HNE_AgingDOE_processed/HNE_FCC/RPT2/25C/4CPD 1C (25-42)',
%     '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL_Data2/HNE_AgingDOE_processed/HNE_FCC/Aging2/4CPD 1C (25-42)',
%     '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL_Data2/HNE_AgingDOE_processed/HNE_FCC/RPT3/25C/4CPD 1C (25-42)',
%     '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL_Data2/HNE_AgingDOE_processed/HNE_FCC/Aging3/4CPD 1C (25-42)',
%     '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL_Data2/HNE_AgingDOE_processed/HNE_FCC/RPT4/25C/4CPD 1C (25-42)',
%     '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL_Data2/HNE_AgingDOE_processed/HNE_FCC/Aging4/4CPD 1C (25-42)'
% 
% };
% 
% I_1C = 0.00429; % [A]
% n_hd = 14; % 'readtable' 옵션에서 사용되는 헤드라인 번호. WonA: 14, Maccor: 3.
% sample_plot = [1];
% 
% save_Path = cell(size(dirPath)); % 수정된 경로를 저장할 셀 배열 초기화
% 
% for i = 1:length(dirPath)
%     % dirPath를 슬래시 기준으로 분리
%     splitPath = split(dirPath{i}, filesep);
% 
%     % "HNE_AgingDOE_processed"가 포함된 인덱스를 찾음
%     index1 = find(strcmp('HNE_AgingDOE_processed', splitPath), 1);
% 
%     % "HNE_AgingDOE_processed" 다음에 "Experiment_data/RPT"를 추가
%     modifiedPath = [splitPath(1:index1); "Experiment_data"; "Combined"];
% 
%     % 수정된 경로를 셀 배열에 저장
%     save_Path{i} = strjoin(modifiedPath, filesep);
% end
% 
% % 새 디렉토리 경로가 존재하지 않으면 생성
% for i = 1:length(save_Path)
%     if ~exist(save_Path{i}, 'dir')
%        mkdir(save_Path{i})
%     end
% end
% 
% 
% 
% % 모든 .mat 파일을 재귀적으로 가져오기
% allFiles = {};
% for i = 1:length(dirPath)
%     files = getAllFiles(dirPath{i}, '*.mat');
%     allFiles = [allFiles; files]; % 결과를 allFiles 배열에 추가
% end
% 
% % 파일 처리 및 구조체에 묶기
% filesStruct = struct();
% pattern = '(\d+).mat'; % 숫자 부분을 찾기 위한 패턴 정의
% 
% for i = 1:length(allFiles)
%     fullpath_now = allFiles{i}; % 현재 파일의 전체 경로
%     [~, fileName, ext] = fileparts(fullpath_now);
% 
%     % 파일 이름에서 숫자 부분 추출
%     match = regexp([fileName, ext], pattern, 'match');
% 
%     if ~isempty(match)
%         numPart = match{1}; % 첫 번째 일치 항목 사용
%         numPart = regexprep(numPart, '.mat', ''); % '.mat' 부분 제거하여 순수 숫자만 남김
% 
%         % 숫자로 시작하면 'CellID_' 접두사 추가 (이미 숫자만 추출되므로 필요 없을 수 있음)
%         numPart = ['CellID_' numPart]; 
% 
%         % 구조체 필드 할당 전 numPart 값 확인
%         disp(['Field name being assigned: ', numPart]);
% 
%         % 구조체에 파일 경로 저장
%         if ~isfield(filesStruct, numPart)
%             filesStruct.(numPart) = {fullpath_now};
%         else
%             filesStruct.(numPart){end+1} = fullpath_now;
%         end
%     end
% end
% 
% 
% 
% baseSavePath = save_Path{1}; % 기본 저장 경로로 save_Path의 첫 번째 항목 사용
% 
% for numPartField = fieldnames(filesStruct)' 
%     numPart = numPartField{1}; 
%     fileList = filesStruct.(numPart); 
% 
%     groupDataStruct = struct(); 
% 
%     for fileIdx = 1:length(fileList)
%         filePath = fileList{fileIdx}; 
%         data = load(filePath); 
% 
%         dataFields = fieldnames(data);
%         for dataField = dataFields'
%             fieldName = dataField{1};
%             if ~isfield(groupDataStruct, fieldName)
%                 groupDataStruct.(fieldName) = data.(fieldName);
%             else
%                 try
%                     groupDataStruct.(fieldName) = vertcat(groupDataStruct.(fieldName), data.(fieldName));
%                 catch
%                     warning('Failed to vertically concatenate field %s due to inconsistent dimensions.', fieldName);
%                 end
%             end
%         end
%     end
% 
%     % 각 numPart 그룹 데이터를 특정 경로에 저장
%     numPartSavePath = fullfile(baseSavePath, numPart); % numPart에 해당하는 저장 경로 생성
%     if ~exist(numPartSavePath, 'dir')
%         mkdir(numPartSavePath); % 디렉토리가 존재하지 않으면 생성
%     end
%     saveFileName = fullfile(numPartSavePath, sprintf('%s_Experiment_data.mat', numPart));
%     save(saveFileName, 'groupDataStruct', '-v7.3');
% end





% 
% %% Helper Function to Recursively Get All Files
% function fileList = getAllFiles(dirName, filePattern)
%     dirData = dir(dirName);      % Get the data for the current directory
%     dirIndex = [dirData.isdir];  % Find the index for directories
%     fileList = {dirData(~dirIndex).name}';  % Get a list of the files
%     if ~isempty(fileList)
%         fileList = cellfun(@(x) fullfile(dirName,x),...  % Convert to full path
%             fileList,'UniformOutput',false);
%     end
%     subDirs = {dirData(dirIndex).name};  % Get a list of sub-directories
%     validIndex = ~ismember(subDirs,{'.','..'});  % Find index of sub-directories excluding '.' and '..'
% 
%     for iDir = find(validIndex)                  % Loop over valid sub-directories
%         nextDir = fullfile(dirName,subDirs{iDir}); % Get the sub-directory path
%         fileList = [fileList; getAllFiles(nextDir, filePattern)];  % Recurse
%     end
% end


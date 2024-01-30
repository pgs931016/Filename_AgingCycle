% save_path 설정
clc; 
clear; 
close all;

slash = filesep;

% load xlxs
old_path = '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL-Data/Data';

% Split the path using the directory separator
splitPath = split(old_path, filesep);

% Find the index of "Data" (to be replaced)
index = find(strcmp('Data', splitPath), 2);

% Replace the first "Data" with "Processed_Data"
splitPath{index} = 'Exercise';
save_path = strjoin(splitPath, filesep);

% 지정된 경로에 directory 생성
if ~exist(save_path, 'dir')
    mkdir(save_path)
end

% Data load
filename = '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL-Data/Data/Hyundai_dataset/Folder_Automation.xlsx';

% 각 시트를 읽어오기 위해 엑셀 파일의 정보를 가져옵니다.
[~, sheetNames] = xlsfinfo(filename);

% 찾고자 하는 문자열
desiredString = 'RPT1';

% 입력한 문자열과 일치하는 시트를 찾아서 데이터를 적용
for idx = 1:length(sheetNames)
    % 엑셀 파일에서 데이터를 읽어와 테이블로 변환합니다.
    data = readtable(filename, 'Sheet', sheetNames{idx});

    % 시트 헤더 가져오기
    sheetHeaders = data.Properties.VariableNames;

    % 입력한 문자열과 시트의 7번째 열의 1행의 문자가 일치하면 데이터 적용
    if strcmp(data.(sheetHeaders{7}){1}, desiredString)
        % 시트의 첫 번째 열의 값을 가져와 폴더 이름으로 설정
        firstColumnData = data.(sheetHeaders{1});
        firstColumnData(cellfun(@(x) isequal(x, 'None') || isempty(x), firstColumnData)) = [];
        uniqueFirstValues = unique(firstColumnData);
        uniqueFirstValues = uniqueFirstValues(~cellfun('isempty', uniqueFirstValues));

        % 두 번째 셀의 첫 번째 값을 가져와 폴더 이름으로 설정
        secondColumnData = data.(sheetHeaders{2});
        secondColumnData(cellfun(@(x) isequal(x, 'None') || isempty(x), secondColumnData)) = [];
        uniqueSecondValues = unique(secondColumnData);
        uniqueSecondValues = uniqueSecondValues(~cellfun('isempty', uniqueSecondValues));

        % 세 번째 셀의 첫 번째 값을 가져와 폴더 이름으로 설정
        thirdColumnData = data.(sheetHeaders{3});
        thirdColumnData(cellfun(@(x) isequal(x, 'None') || isempty(x), thirdColumnData)) = [];
        uniqueThirdValues = unique(thirdColumnData);
        uniqueThirdValues = uniqueThirdValues(~cellfun('isempty', uniqueThirdValues));

        % 폴더 생성
        for i = 1:length(uniqueFirstValues)
            folderPath1 = fullfile(save_path, uniqueFirstValues{i});
            if ~exist(folderPath1, 'dir')
                mkdir(folderPath1);
            end

            for j = 1:length(uniqueSecondValues)
                folderPath2 = fullfile(folderPath1, uniqueSecondValues{j});
                if ~exist(folderPath2, 'dir')
                    mkdir(folderPath2);
                end

                for k = 1:length(uniqueThirdValues)
                    folderPath3 = fullfile(folderPath2, uniqueThirdValues{k});
                    if ~exist(folderPath3, 'dir')
                        mkdir(folderPath3);
                    end
                end
            end
        end
        break; % 일치하는 시트를 찾았으므로 루프 중단
    end
end

% RPT1 폴더 내의 파일들을 가져와서 처리
rpt1_path = '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL-Data/Data/Hyundai_dataset/AgingDOE_All/AgingDOE_cycle1/RPT1';
filesInRPT1 = dir(fullfile(rpt1_path, '*.txt'));

for i = 1:length(filesInRPT1)
    currentFile = fullfile(rpt1_path, filesInRPT1(i).name);
    [~, fileName, fileExt] = fileparts(currentFile);

    % 언더스코어(_)로 파일 이름을 분리
    fileName = strrep(fileName, '_DC', ''); % 파일 이름에서 '_DC' 제거
    parts = strsplit(fileName, '_');

    if length(parts) >= 2
        numPart = str2double(parts{end});
        

        % 해당 파일을 sheetHeaders{5}열 값 찾기
        for idx = 1:length(sheetNames)
            % 엑셀 파일에서 데이터를 읽어와 테이블로 변환합니다.
            data = readtable(filename, 'Sheet', sheetNames{idx});

  % 시트 헤더 가져오기

 sheetHeaders = data.Properties.VariableNames;

                    if ismember('sheetHeader{5}', sheetHeaders)
                        fifthColumnData = data.(sheetHeaders{5});
                        fifthColumnData(cellfun(@(x) isequal(x, 'None') || isempty(x), fifthColumnData)) = [];
                        fifthColumnData = str2double(fifthColumnData);

                        % sheetHeaders{5}와 numPart가 일치하는 경우
                        if any(fifthColumnData == numPart)
                            % numPart와 일치하는 인덱스 찾기
                            idxMatch = find(fifthColumnData == numPart);

                            % sheetHeaders{2}와 sheetHeaders{3}에 폴더 분배
                            for matchIdx = 1:length(idxMatch)
                                idxToUse = idxMatch(matchIdx);
                                secondValue = data.(sheetHeaders{2}){idxToUse};
                                thirdValue = data.(sheetHeaders{3}){idxToUse};
                                folderPath2 = fullfile(save_path, secondValue);
                                folderPath3 = fullfile(folderPath2, thirdValue);
                                if ~exist(folderPath3, 'dir')
                                    mkdir(folderPath3);
                                end

                                % 파일을 복사하려면 여기에 코드를 추가
                                copyfile(currentFile, folderPath3);
                            end
                        end
                    end
                end
            end

        break;
end

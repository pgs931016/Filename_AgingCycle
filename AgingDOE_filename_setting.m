clc; clear; close all

% 루트 디렉토리 설정
rootDir = '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL-Data/Hyundai_dataset/AgingDOE_cycle1/AgingDOE/HNE_FCC_1CPD_0.5c_V2542_231124_cyc/231127';

% 루트 디렉토리 내의 모든 폴더 목록 가져오기 (하위 폴더 포함)
allFolders = dir(rootDir);
allFolders = allFolders(~ismember({allFolders.name}, {'.', '..'}));

a = [1:26,41:66,81:128,27:37,67:77]'; %지그번호
b = [02,05,06,10,11,14,16:24,27:32,34:36,38:39,95:99,101:113,116:123,40:53,55:57,59:64,66:71,73:82,84:87,89:93,1,3,4,7:9,12,13,15,25,26,33,54,58,65,72,83,88,94,100,114,115]'; %셀번호
c = horzcat(a, b);

% 루트 디렉토리 내의 각 폴더에 대해 작업
for i = 1:length(allFolders)
    currentDir = fullfile(rootDir, allFolders(i).name);
    
    % 끝째 폴더의 이름 추출
    folderParts = strsplit(rootDir, filesep);
    replacementName = folderParts{end-1};
    replacementName = regexprep(replacementName, '_231124_cyc$', '');
    % % 현재 폴더 내의 모든 txt 파일 가져오기 (하위 폴더 포함)
    % files = dir(fullfile(currentDir, '*.txt'));

    % 각 파일에 대해 작업

        oldFilePath = fullfile(currentDir);
        fprintf('Processing file: %s\n', oldFilePath);

        % 파일 이름에서 필요한 부분 추출
        [~, fileName, fileExt] = fileparts(allFolders(i).name);

        % 언더스코어(_)로 파일 이름을 분리
        parts = strsplit(fileName, '_');

        % 파일 이름 재구성
        if length(parts) >= 3
            % _108 부분에서 숫자 추출
            numPart = str2double(parts{2});

               idx = find(a == numPart);
            
             if ~isempty(idx)
                prefix1 = b(idx);
             else
                prefix1 = '';
             end

            % % 조건에 따라 prefix 설정
             if numPart >= 1 && numPart <= 37
                 prefix2 = '25degC';
             elseif numPart >= 41 && numPart <= 77
                 prefix2 = '-10degC';
             elseif numPart >= 81 && numPart <= 128
                 prefix2 = '10degC';
             else
                 prefix2 = '';
             end


            % 파일 이름 앞부분에 prefix를 추가
            
            newFileName = sprintf('%s_%d_%s_%d%s', replacementName, prefix2, prefix1, str2double(parts{2}), fileExt);

            % newFileName = strrep(newFileName, '_DC', ''); % _DC 삭제
            
        newFilePath= fullfile(rootDir, newFileName);
        success = movefile(oldFilePath, newFilePath);
        end
end
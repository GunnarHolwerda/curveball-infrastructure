import * as path from 'path';

export const InfrastructureDir = path.resolve('../infrastructure');
export const RealtimeDir = path.resolve('../realtime');
export const QuizDir = RealtimeDir;
export const CurveballControlDir = path.resolve('../curveball-control');

export const BackUpDir = `${InfrastructureDir}/backups`;
export const SchemaDir = `${InfrastructureDir}/schema`;
export const CertsDir = `${InfrastructureDir}/certs`;

export const DbContainerName = 'curveball-db';
export const RealtimeContainerName = 'curveball-realtime';
export const CacheContainerName = 'curveball-cache';

export const DockerDirs = [RealtimeDir, CurveballControlDir];

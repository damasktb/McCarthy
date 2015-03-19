/* dtstb20 Damask Talary-Brown

THIS WORK IS ENTIRELY MY OWN.

The program does <or does not, choose which is appropriate> produce multiple answers.

I have not used built-ins.

1. <1747 elements in the list binding Q after executing s1(Q,100)>
s1 does four things: 
			Generates a list of [X,Y,S,P] where 1<X<Y and X+Y<=100
			Sorts this list by ascending product
			Removes all tuples whose products P are unique in the list of tuples
			Sorts this new list by ascending sum

2. <145 elements in the list binding Q after executing s2(Q,100)>
s2 does four things:
			Performs s1, noting the list of sums corresponding to unique products
			Sorts the list of sums, reducing duplicate elements so none appear more than once
			Removes any tuple whose sum is in the list of sums corresponding to unique products
			Sorts tuples ascending product

3. <86 elements in the list binding Q after executing s3(Q,100)>
s3 does three things:
			Performs s2
			Removes any tuple whose product appears more than once in the list of tuples
			Sorts the tuples by ascending sum

4.
s4 does two things:
			Performs s3
			Removes any tuple whose sum appears more than once in the list of tuples

5. <1 element in the list binding Q after executing s4(Q,500)>
s4(Q,500) uses <20,042,723> inferences. */

%--- S1 -------------------------- Generate List sorted by sum, sort by product, remove unique products, sort by sum

s1(Q,Max) :- s1(Q,Max,_), !.
s1(Q,Max,Sums) :- 	makeTuple(2,3,Max,Tuple), 
					mergeSortP(Tuple,PSorted),
					noUniqueProducts(PSorted,NoUniques,Sums),
					mergeSortS(NoUniques,Q),
					!.

% makeTuple(Start X, Start Y, MaxSum, Tuples)
makeTuple(X,Y,Max,[[X,Y,S,P]|T]) :- X+Y =< Max, !, 
									S is X+Y, 
									P is X*Y, 
									Y2 is Y+1, 
									makeTuple(X,Y2,Max,T).
makeTuple(X,_,Max,T) :- X+X+2=<Max, !, 
						X2 is X+1, 
						Y2 is X2+1, 
						makeTuple(X2,Y2,Max,T).
makeTuple(_,_,_,[]) :- !.

alternates([],[],[]).
alternates([X],[X],[]).
alternates([X,Y|[]],[X],[Y]).
alternates([X,Y,Z|[]],[X,Z],[Y]).
alternates([W,X,Y,Z|[]],[W,Y],[X,Z]).
alternates([Lh,Rh|T],[Lh|Lt],[Rh|Rt]) :- alternates(T,Lt,Rt).
 
mergeSortP([],[]).
mergeSortP([X],[X]).
mergeSortP([[X1,Y1,S1,P1],[X2,Y2,S2,P2]],[[X1,Y1,S1,P1],[X2,Y2,S2,P2]]) :- P1=<P2.
mergeSortP([[X1,Y1,S1,P1],[X2,Y2,S2,P2]],[[X2,Y2,S2,P2],[X1,Y1,S1,P1]]) :- P1>P2.
mergeSortP([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]]) :- P1=<P2,P2=<P3.
mergeSortP([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X1,Y1,S1,P1],[X3,Y3,S3,P3],[X2,Y2,S2,P2]]) :- P1=<P3,P3=<P2.
mergeSortP([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X3,Y3,S3,P3],[X2,Y2,S2,P2],[X1,Y1,S1,P1]]) :- P3=<P2,P2=<P1.
mergeSortP([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X3,Y3,S3,P3],[X1,Y1,S1,P1],[X2,Y2,S2,P2]]) :- P3=<P1,P1=<P2.
mergeSortP([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X2,Y2,S2,P2],[X1,Y1,S1,P1],[X3,Y3,S3,P3]]) :- P2=<P1,P1=<P3.
mergeSortP([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X2,Y2,S2,P2],[X3,Y3,S3,P3],[X1,Y1,S1,P1]]) :- P2=<P3,P3=<P1.
mergeSortP(List,Sorted) :- 	alternates(List,L,R), 
							mergeSortP(L,SortedL), 
							mergeSortP(R,SortedR), 
							mergeP(SortedL,SortedR,Sorted).
mergeP([],R,R).
mergeP(L,[],L).
mergeP([Lh|Lt],[Rh|Rt],[Lh|T]) :-	[_,_,_,P1] = Lh, 
									[_,_,_,P2] = Rh, 
									P1 =< P2, 
									mergeP(Lt,[Rh|Rt],T).
mergeP([Lh|Lt],[Rh|Rt],[Rh|T]) :- 	[_,_,_,P1] = Lh, 
									[_,_,_,P2] = Rh, 
									P1 > P2,
									mergeP([Lh|Lt],Rt,T).

noUniqueProducts([],[],[]).
noUniqueProducts([[X1,Y1,S1,P],[X2,Y2,S2,P],[X3,Y3,S3,P]|T],[[X1,Y1,S1,P]|L], Sums) :- noUniqueProducts([[X2,Y2,S2,P],[X3,Y3,S3,P]|T],L,Sums).
noUniqueProducts([[X1,Y1,S1,P],[X2,Y2,S2,P]|T],[[X1,Y1,S1,P],[X2,Y2,S2,P]|L],Sums) :- noUniqueProducts(T,L,Sums).
noUniqueProducts([[_,_,S,_]|T],Result,[S|Sums]) :- noUniqueProducts(T,Result,Sums).

mergeSortS([],[]).
mergeSortS([X],[X]).
mergeSortS([[X1,Y1,S1,P1],[X2,Y2,S2,P2]],[[X1,Y1,S1,P1],[X2,Y2,S2,P2]]) :- S1=<S2.
mergeSortS([[X1,Y1,S1,P1],[X2,Y2,S2,P2]],[[X2,Y2,S2,P2],[X1,Y1,S1,P1]]) :- S1>S2.
mergeSortS([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]]) :- S1=<S2,S2=<S3.
mergeSortS([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X1,Y1,S1,P1],[X3,Y3,S3,P3],[X2,Y2,S2,P2]]) :- S1=<S3,S3=<S2.
mergeSortS([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X3,Y3,S3,P3],[X2,Y2,S2,P2],[X1,Y1,S1,P1]]) :- S3=<S2,S2=<S1.
mergeSortS([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X3,Y3,S3,P3],[X1,Y1,S1,P1],[X2,Y2,S2,P2]]) :- S3=<S1,S1=<S2.
mergeSortS([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X2,Y2,S2,P2],[X1,Y1,S1,P1],[X3,Y3,S3,P3]]) :- S2=<S1,S1=<S3.
mergeSortS([[X1,Y1,S1,P1],[X2,Y2,S2,P2],[X3,Y3,S3,P3]],[[X2,Y2,S2,P2],[X3,Y3,S3,P3],[X1,Y1,S1,P1]]) :- S2=<S3,S3=<S1.
mergeSortS(List,Sorted) :- 	alternates(List,L,R), 
							mergeSortS(L, SortedL), 
							mergeSortS(R, SortedR), 
							mergeS(SortedL,SortedR,Sorted).
mergeS([],R,R).
mergeS(L,[],L).
mergeS([Lh|Lt],[Rh|Rt],[Lh|T]) :-	[_,_,S1,_] = Lh, 
									[_,_,S2,_] = Rh, 
									S1 =< S2, 
									mergeS(Lt,[Rh|Rt],T).
mergeS([Lh|Lt],[Rh|Rt],[Rh|T]) :- 	[_,_,S1,_] = Lh, 
									[_,_,S2,_] = Rh, 
									S1 > S2,
									mergeS([Lh|Lt],Rt,T).



%--- S2 -------------------------- Get list, remove sums corresponding to unique products, sort by product

s2(Q,Max) :- 	s1(S1,Max,Sums),
				mergeSort(Sums,UniquePSList),
				noSumsWUniqueProducts(S1,UniquePSList,NoSumUniques),
				mergeSortP(NoSumUniques, Q),
				!.

mergeSort([],[]).
mergeSort([X],[X]).
mergeSort([X,Y],[X,Y]) :- X=<Y.
mergeSort([X,Y],[Y,X]) :- X>Y.
mergeSort([X,Y,Z],[X,Y,Z]) :- X=<Y,Y=<Z.
mergeSort([X,Y,Z],[X,Z,Y]) :- X=<Z,Z=<Y.
mergeSort([X,Y,Z],[Z,Y,X]) :- Z=<Y,Y=<X.
mergeSort([X,Y,Z],[Z,X,Y]) :- Z=<X,X=<Y.
mergeSort([X,Y,Z],[Y,X,Z]) :- Y=<X,X=<Z.
mergeSort([X,Y,Z],[Y,Z,X]) :- Y=<Z,Z=<X.
mergeSort(List,Sorted) :- 	alternates(List,L,R), 
							mergeSort(L, SortedL), 
							mergeSort(R, SortedR), 
							merge(SortedL,SortedR,Sorted).
merge([],R,R).
merge(L,[],L).
merge([Lh|Lt],[Lh|Rt],Sorted) :- merge([Lh|Lt],Rt,Sorted).

merge([Lh|Lt],[Rh|Rt],[Lh|T]) :-	Lh =< Rh, 
									merge(Lt,[Rh|Rt],T).
merge([Lh|Lt],[Rh|Rt],[Rh|T]) :- 	Lh > Rh,  
									merge([Lh|Lt],Rt,T).


%noSumsWUniqueProducts(Quads, Sums, Result)
noSumsWUniqueProducts([],_,[]) :- !.
noSumsWUniqueProducts([[X,Y,S,P]|Qt],[Sum|St],[[X,Y,S,P]|Result]) :- S<Sum, !, noSumsWUniqueProducts(Qt,[Sum|St],Result).
noSumsWUniqueProducts([[X,Y,S,P]|Qt],[Sum|St],Result) :- S>Sum, !, noSumsWUniqueProducts([[X,Y,S,P]|Qt],St,Result).
noSumsWUniqueProducts([_|Qt],Sums,Result) :- noSumsWUniqueProducts(Qt,Sums,Result).

%--- S3 -------------------------- Remove duplicate products from the list sort by sum

s3(Q,Max) :- 	s2(S2,Max),
				noDuplicateProducts(S2,UniqueProducts),
				mergeSortS(UniqueProducts,Q),
				!.

noDuplicateProducts([],[]) :- !.
noDuplicateProducts([[_,_,_,P],[X1,Y1,S1,P],[X2,Y2,S2,P]|T],Unique) :- noDuplicateProducts([[X1,Y1,S1,P],[X2,Y2,S2,P]|T], Unique), !.
noDuplicateProducts([[_,_,_,P],[_,_,_,P]|T],Unique) :- noDuplicateProducts(T, Unique), !.
noDuplicateProducts([H|T],[H|NewTail]) :- noDuplicateProducts(T,NewTail), !.


%--- S4 -------------------------- Remove duplicate sums from the list

s4(Q,Max) :- 	s3(S3,Max),
				noDuplicateSums(S3,Q),
				!.
noDuplicateSums([],[]) :- !.
noDuplicateSums([[_,_,S,_],[X1,Y1,S,P1],[X2,Y2,S,P2]|T],Unique) :- 	noDuplicateSums([[X1,Y1,S,P1],[X2,Y2,S,P2]|T], Unique), !.
noDuplicateSums([[_,_,S,_],[_,_,S,_]|T],Unique) :- noDuplicateSums(T, Unique), !.
noDuplicateSums([H|T],[H|NewTail]) :- noDuplicateSums(T,NewTail), !.


/*
?- consult(dtstb20).
% dtstb20 compiled 0.01 sec, 76 clauses
true.
?- time(s1(Q,100)).
% 134,483 inferences, 0.083 CPU in 0.092 seconds (90% CPU, 1627611 Lips)
Q = [[3,4,7,12],[2,6,8,12],[4,5,9,20],[3,6,9,18],[4,6,10,24],[5,6,11,30],[3,8,11,24],[4,7,11,28],[2,9,11,18],[4,8,12,32],[2,10,12,20],[6,7,13,42],[4,9,13,36],[3,10,13,30],[5,8,13,40],[6,8,14,48],[4,10,14,40],[5,9,14,45],[2,12,14,24],[3,12,15,36],[7,8,15,56],[5,10,15,50],[6,9,15,54],[4,11,15,44],[2,14,16,28],[4,12,16,48],[7,9,16,63],[6,10,16,60],[3,14,17,42],[6,11,17,66],[8,9,17,72],[4,13,17,52],[2,15,17,30],[5,12,17,60],[7,10,17,70],[3,15,18,45],[4,14,18,56],[8,10,18,80],[2,16,18,32],[6,12,18,72],[9,10,19,90],[7,12,19,84],[5,14,19,70],[6,13,19,78],[8,11,19,88],[4,15,19,60],[3,16,19,48],[5,15,20,75],[2,18,20,36],[4,16,20,64],[8,12,20,96],[9,11,20,99],[6,14,20,84],[7,14,21,98],[5,16,21,80],[6,15,21,90],[8,13,21,104],[9,12,21,108],[10,11,21,110],[3,18,21,54],[4,17,21,68],[4,18,22,72],[2,20,22,40],[7,15,22,105],[9,13,22,117],[8,14,22,112],[10,12,22,120],[6,16,22,96],[11,12,23,132],[7,16,23,112],[10,13,23,130],[3,20,23,60],[9,14,23,126],[6,17,23,102],[8,15,23,120],[4,19,23,76],[2,21,23,42],[5,18,23,90],[3,21,24,63],[6,18,24,108],[4,20,24,80],[2,22,24,44],[8,16,24,128],[10,14,24,140],[9,15,24,135],[7,18,25,126],[5,20,25,100],[6,19,25,114],[4,21,25,84],[3,22,25,66],[10,15,25,150],[12,13,25,156],[9,16,25,144],[8,17,25,136],[11,14,25,154],[9,17,26,153],[12,14,26,168],[6,20,26,120],[10,16,26,160],[5,21,26,105],[4,22,26,88],[11,15,26,165],[8,18,26,144],[2,24,26,48],[13,14,27,182],[12,15,27,180],[3,24,27,72],[7,20,27,140],[9,18,27,162],[2,25,27,50],[4,23,27,92],[8,19,27,152],[6,21,27,126],[10,17,27,170],[11,16,27,176],[5,22,27,110],[7,21,28,147],[2,26,28,52],[4,24,28,96],[10,18,28,180],[8,20,28,160],[6,22,28,132],[12,16,28,192],[3,25,28,75],[13,15,28,195],[9,19,28,171],[7,22,29,154],[14,15,29,210],[6,23,29,138],[11,18,29,198],[12,17,29,204],[8,21,29,168],[13,16,29,208],[10,19,29,190],[5,24,29,120],[2,27,29,54],[4,25,29,100],[9,20,29,180],[3,26,29,78],[6,24,30,144],[4,26,30,104],[8,22,30,176],[10,20,30,200],[14,16,30,224],[9,21,30,189],[2,28,30,56],[12,18,30,216],[9,22,31,198],[13,18,31,234],[4,27,31,108],[14,17,31,238],[8,23,31,184],[11,20,31,220],[10,21,31,210],[5,26,31,130],[7,24,31,168],[3,28,31,84],[15,16,31,240],[12,19,31,228],[6,25,31,150],[11,21,32,231],[10,22,32,220],[2,30,32,60],[5,27,32,135],[12,20,32,240],[4,28,32,112],[8,24,32,192],[6,26,32,156],[15,17,32,255],[7,25,32,175],[9,23,32,207],[14,18,32,252],[13,20,33,260],[3,30,33,90],[10,23,33,230],[12,21,33,252],[5,28,33,140],[8,25,33,200],[7,26,33,182],[15,18,33,270],[6,27,33,162],[9,24,33,216],[14,19,33,266],[4,29,33,116],[16,17,33,272],[7,27,34,189],[8,26,34,208],[16,18,34,288],[14,20,34,280],[6,28,34,168],[9,25,34,225],[13,21,34,273],[12,22,34,264],[4,30,34,120],[2,32,34,64],[15,19,34,285],[10,24,34,240],[16,19,35,304],[13,22,35,286],[10,25,35,250],[4,31,35,124],[2,33,35,66],[5,30,35,150],[11,24,35,264],[8,27,35,216],[17,18,35,306],[7,28,35,196],[14,21,35,294],[6,29,35,174],[15,20,35,300],[3,32,35,96],[12,23,35,276],[9,26,35,234],[6,30,36,180],[16,20,36,320],[2,34,36,68],[9,27,36,243],[15,21,36,315],[3,33,36,99],[4,32,36,128],[10,26,36,260],[14,22,36,308],[11,25,36,275],[8,28,36,224],[12,24,36,288],[17,20,37,340],[3,34,37,102],[7,30,37,210],[18,19,37,342],[14,23,37,322],[16,21,37,336],[5,32,37,160],[9,28,37,252],[4,33,37,132],[11,26,37,286],[2,35,37,70],[10,27,37,270],[6,31,37,186],[15,22,37,330],[12,25,37,300],[13,24,37,312],[8,29,37,232],[6,32,38,192],[17,21,38,357],[8,30,38,240],[15,23,38,345],[2,36,38,72],[4,34,38,136],[10,28,38,280],[5,33,38,165],[13,25,38,325],[11,27,38,297],[14,24,38,336],[16,22,38,352],[3,35,38,105],[9,29,38,261],[12,26,38,312],[18,20,38,360],[3,36,39,108],[14,25,39,350],[5,34,39,170],[9,30,39,270],[10,29,39,290],[6,33,39,198],[8,31,39,248],[12,27,39,324],[7,32,39,224],[19,20,39,380],[15,24,39,360],[16,23,39,368],[4,35,39,140],[18,21,39,378],[11,28,39,308],[17,22,39,374],[2,38,40,76],[9,31,40,279],[7,33,40,231],[14,26,40,364],[5,35,40,175],[4,36,40,144],[10,30,40,300],[16,24,40,384],[15,25,40,375],[18,22,40,396],[12,28,40,336],[19,21,40,399],[13,27,40,351],[6,34,40,204],[8,32,40,256],[20,21,41,420],[18,23,41,414],[12,29,41,348],[4,37,41,148],[19,22,41,418],[9,32,41,288],[10,31,41,310],[11,30,41,330],[16,25,41,400],[5,36,41,180],[17,24,41,408],[6,35,41,210],[7,34,41,238],[15,26,41,390],[2,39,41,78],[14,27,41,378],[3,38,41,114],[13,28,41,364],[8,33,41,264],[9,33,42,297],[20,22,42,440],[18,24,42,432],[12,30,42,360],[3,39,42,117],[6,36,42,216],[7,35,42,245],[8,34,42,272],[2,40,42,80],[16,26,42,416],[10,32,42,320],[17,25,42,425],[14,28,42,392],[15,27,42,405],[4,38,42,152],[10,33,43,330],[3,40,43,120],[9,34,43,306],[11,32,43,352],[12,31,43,372],[17,26,43,442],[14,29,43,406],[19,24,43,456],[20,23,43,460],[16,27,43,432],[18,25,43,450],[4,39,43,156],[6,37,43,222],[21,22,43,462],[15,28,43,420],[5,38,43,190],[13,30,43,390],[8,35,43,280],[7,36,43,252],[17,27,44,459],[2,42,44,84],[9,35,44,315],[5,39,44,195],[20,24,44,480],[21,23,44,483],[15,29,44,435],[18,26,44,468],[14,30,44,420],[12,32,44,384],[16,28,44,448],[19,25,44,475],[6,38,44,228],[10,34,44,340],[4,40,44,160],[8,36,44,288],[14,31,45,434],[11,34,45,374],[12,33,45,396],[17,28,45,476],[7,38,45,266],[5,40,45,200],[15,30,45,450],[9,36,45,324],[19,26,45,494],[22,23,45,506],[20,25,45,500],[16,29,45,464],[8,37,45,296],[10,35,45,350],[6,39,45,234],[18,27,45,486],[13,32,45,416],[21,24,45,504],[3,42,45,126],[4,41,45,164],[16,30,46,480],[2,44,46,88],[8,38,46,304],[14,32,46,448],[18,28,46,504],[13,33,46,429],[22,24,46,528],[6,40,46,240],[10,36,46,360],[12,34,46,408],[21,25,46,525],[4,42,46,168],[19,27,46,513],[11,35,46,385],[15,31,46,465],[20,26,46,520],[7,39,46,273],[17,30,47,510],[4,43,47,172],[16,31,47,496],[21,26,47,546],[8,39,47,312],[10,37,47,370],[15,32,47,480],[5,42,47,210],[7,40,47,280],[11,36,47,396],[20,27,47,540],[23,24,47,552],[14,33,47,462],[9,38,47,342],[2,45,47,90],[13,34,47,442],[19,28,47,532],[3,44,47,132],[6,41,47,246],[12,35,47,420],[18,29,47,522],[22,25,47,550],[4,44,48,176],[21,27,48,567],[18,30,48,540],[3,45,48,135],[16,32,48,512],[6,42,48,252],[9,39,48,351],[22,26,48,572],[2,46,48,92],[13,35,48,455],[8,40,48,320],[15,33,48,495],[12,36,48,432],[14,34,48,476],[10,38,48,380],[20,28,48,560],[13,36,49,468],[23,26,49,598],[3,46,49,138],[7,42,49,294],[20,29,49,580],[8,41,49,328],[9,40,49,360],[19,30,49,570],[10,39,49,390],[14,35,49,490],[17,32,49,544],[15,34,49,510],[6,43,49,258],[16,33,49,528],[18,31,49,558],[5,44,49,220],[12,37,49,444],[22,27,49,594],[11,38,49,418],[24,25,49,600],[21,28,49,588],[4,45,49,180],[18,32,50,576],[21,29,50,609],[16,34,50,544],[4,46,50,184],[6,44,50,264],[24,26,50,624],[15,35,50,525],[20,30,50,600],[2,48,50,96],[23,27,50,621],[17,33,50,561],[22,28,50,616],[14,36,50,504],[11,39,50,429],[10,40,50,400],[5,45,50,225],[8,42,50,336],[12,38,50,456],[18,33,51,594],[15,36,51,540],[21,30,51,630],[14,37,51,518],[6,45,51,270],[4,47,51,188],[3,48,51,144],[7,44,51,308],[12,39,51,468],[2,49,51,98],[9,42,51,378],[16,35,51,560],[11,40,51,440],[23,28,51,644],[19,32,51,608],[10,41,51,410],[13,38,51,494],[24,27,51,648],[20,31,51,620],[8,43,51,344],[22,29,51,638],[25,26,51,650],[5,46,51,230],[14,38,52,532],[17,35,52,595],[24,28,52,672],[6,46,52,276],[22,30,52,660],[2,50,52,100],[8,44,52,352],[7,45,52,315],[16,36,52,576],[3,49,52,147],[19,33,52,627],[18,34,52,612],[21,31,52,651],[10,42,52,420],[20,32,52,640],[12,40,52,480],[4,48,52,192],[25,27,52,675],[21,32,53,672],[11,42,53,462],[10,43,53,430],[3,50,53,150],[24,29,53,696],[5,48,53,240],[26,27,53,702],[17,36,53,612],[13,40,53,520],[14,39,53,546],[23,30,53,690],[18,35,53,630],[4,49,53,196],[25,28,53,700],[12,41,53,492],[20,33,53,660],[19,34,53,646],[15,38,53,570],[22,31,53,682],[8,45,53,360],[6,47,53,282],[7,46,53,322],[16,37,53,592],[2,51,53,102],[9,44,53,396],[20,34,54,680],[14,40,54,560],[15,39,54,585],[6,48,54,288],[8,46,54,368],[21,33,54,693],[22,32,54,704],[9,45,54,405],[5,49,54,245],[26,28,54,728],[18,36,54,648],[3,51,54,153],[2,52,54,104],[12,42,54,504],[24,30,54,720],[10,44,54,440],[4,50,54,200],[16,38,54,608],[23,32,55,736],[22,33,55,726],[17,38,55,646],[27,28,55,756],[21,34,55,714],[3,52,55,156],[9,46,55,414],[12,43,55,516],[15,40,55,600],[18,37,55,666],[26,29,55,754],[4,51,55,204],[7,48,55,336],[24,31,55,744],[6,49,55,294],[10,45,55,450],[13,42,55,546],[8,47,55,376],[14,41,55,574],[5,50,55,250],[20,35,55,700],[16,39,55,624],[25,30,55,750],[19,36,55,684],[10,46,56,460],[17,39,56,663],[18,38,56,684],[27,29,56,783],[23,33,56,759],[14,42,56,588],[5,51,56,255],[16,40,56,640],[20,36,56,720],[11,45,56,495],[22,34,56,748],[24,32,56,768],[2,54,56,108],[12,44,56,528],[6,50,56,300],[21,35,56,735],[8,48,56,384],[4,52,56,208],[26,30,56,780],[24,33,57,792],[16,41,57,656],[22,35,57,770],[15,42,57,630],[3,54,57,162],[8,49,57,392],[12,45,57,540],[28,29,57,812],[21,36,57,756],[2,55,57,110],[23,34,57,782],[7,50,57,350],[13,44,57,572],[17,40,57,680],[20,37,57,740],[27,30,57,810],[11,46,57,506],[10,47,57,470],[18,39,57,702],[6,51,57,306],[26,31,57,806],[14,43,57,602],[5,52,57,260],[9,48,57,432],[25,32,57,800],[8,50,58,400],[19,39,58,741],[13,45,58,585],[12,46,58,552],[4,54,58,216],[3,55,58,165],[14,44,58,616],[2,56,58,112],[10,48,58,480],[6,52,58,312],[24,34,58,816],[9,49,58,441],[22,36,58,792],[28,30,58,840],[7,51,58,357],[16,42,58,672],[20,38,58,760],[18,40,58,720],[25,33,58,825],[26,32,58,832],[12,47,59,564],[10,49,59,490],[9,50,59,450],[7,52,59,364],[3,56,59,168],[11,48,59,528],[21,38,59,798],[25,34,59,850],[22,37,59,814],[23,36,59,828],[14,45,59,630],[20,39,59,780],[27,32,59,864],[15,44,59,660],[29,30,59,870],[2,57,59,114],[24,35,59,840],[16,43,59,688],[26,33,59,858],[13,46,59,598],[18,41,59,738],[19,40,59,760],[28,31,59,868],[17,42,59,714],[5,54,59,270],[4,55,59,220],[8,51,59,408],[2,58,60,116],[20,40,60,800],[8,52,60,416],[18,42,60,756],[16,44,60,704],[4,56,60,224],[26,34,60,884],[28,32,60,896],[22,38,60,836],[5,55,60,275],[15,45,60,675],[3,57,60,171],[11,49,60,539],[9,51,60,459],[24,36,60,864],[21,39,60,819],[10,50,60,500],[14,46,60,644],[12,48,60,576],[6,54,60,324],[27,33,60,891],[13,48,61,624],[22,39,61,858],[29,32,61,928],[23,38,61,874],[11,50,61,550],[7,54,61,378],[18,43,61,774],[3,58,61,174],[21,40,61,840],[6,55,61,330],[28,33,61,924],[4,57,61,228],[17,44,61,748],[30,31,61,930],[25,36,61,900],[26,35,61,910],[19,42,61,798],[10,51,61,510],[16,45,61,720],[12,49,61,588],[20,41,61,820],[5,56,61,280],[24,37,61,888],[15,46,61,690],[27,34,61,918],[9,52,61,468],[2,60,62,120],[26,36,62,936],[20,42,62,840],[4,58,62,232],[7,55,62,385],[24,38,62,912],[28,34,62,952],[14,48,62,672],[10,52,62,520],[6,56,62,336],[30,32,62,960],[16,46,62,736],[18,44,62,792],[12,50,62,600],[23,39,62,897],[5,57,62,285],[22,40,62,880],[29,33,62,957],[13,49,62,637],[27,35,62,945],[17,45,62,765],[8,54,62,432],[11,51,62,561],[13,50,63,650],[17,46,63,782],[19,44,63,836],[25,38,63,950],[11,52,63,572],[23,40,63,920],[20,43,63,860],[9,54,63,486],[8,55,63,440],[12,51,63,612],[28,35,63,980],[22,41,63,902],[5,58,63,290],[31,32,63,992],[27,36,63,972],[24,39,63,936],[6,57,63,342],[18,45,63,810],[29,34,63,986],[30,33,63,990],[21,42,63,882],[3,60,63,180],[26,37,63,962],[7,56,63,392],[15,48,63,720],[4,60,64,240],[8,56,64,448],[24,40,64,960],[20,44,64,880],[7,57,64,399],[18,46,64,828],[25,39,64,975],[15,49,64,735],[19,45,64,855],[22,42,64,924],[12,52,64,624],[14,50,64,700],[16,48,64,768],[26,38,64,988],[30,34,64,1020],[13,51,64,663],[6,58,64,348],[28,36,64,1008],[10,54,64,540],[2,62,64,124],[9,55,64,495],[15,50,65,750],[16,49,65,784],[2,63,65,126],[25,40,65,1000],[29,36,65,1044],[5,60,65,300],[14,51,65,714],[3,62,65,186],[31,34,65,1054],[27,38,65,1026],[22,43,65,946],[10,55,65,550],[11,54,65,594],[30,35,65,1050],[23,42,65,966],[19,46,65,874],[20,45,65,900],[28,37,65,1036],[9,56,65,504],[7,58,65,406],[8,57,65,456],[21,44,65,924],[32,33,65,1056],[26,39,65,1014],[24,41,65,984],[17,48,65,816],[6,60,66,360],[15,51,66,765],[18,48,66,864],[30,36,66,1080],[27,39,66,1053],[9,57,66,513],[24,42,66,1008],[14,52,66,728],[10,56,66,560],[16,50,66,800],[4,62,66,248],[28,38,66,1064],[12,54,66,648],[20,46,66,920],[26,40,66,1040],[32,34,66,1088],[22,44,66,968],[2,64,66,128],[8,58,66,464],[21,45,66,945],[3,63,66,189],[4,63,67,252],[9,58,67,522],[18,49,67,882],[3,64,67,192],[13,54,67,702],[7,60,67,420],[15,52,67,780],[25,42,67,1050],[33,34,67,1122],[29,38,67,1102],[2,65,67,130],[11,56,67,616],[28,39,67,1092],[16,51,67,816],[19,48,67,912],[24,43,67,1032],[23,44,67,1012],[27,40,67,1080],[30,37,67,1110],[17,50,67,850],[32,35,67,1120],[5,62,67,310],[10,57,67,570],[12,55,67,660],[22,45,67,990],[26,41,67,1066],[31,36,67,1116],[21,46,67,966],[4,64,68,256],[11,57,68,627],[28,40,68,1120],[26,42,68,1092],[3,65,68,195],[30,38,68,1140],[22,46,68,1012],[16,52,68,832],[6,62,68,372],[13,55,68,715],[12,56,68,672],[24,44,68,1056],[20,48,68,960],[8,60,68,480],[29,39,68,1131],[5,63,68,315],[33,35,68,1155],[10,58,68,580],[23,45,68,1035],[18,50,68,900],[2,66,68,132],[14,54,68,756],[32,36,68,1152],[31,38,69,1178],[11,58,69,638],[34,35,69,1190],[33,36,69,1188],[25,44,69,1100],[29,40,69,1160],[32,37,69,1184],[17,52,69,884],[6,63,69,378],[30,39,69,1170],[27,42,69,1134],[12,57,69,684],[7,62,69,434],[19,50,69,950],[26,43,69,1118],[28,41,69,1148],[5,64,69,320],[18,51,69,918],[14,55,69,770],[20,49,69,980],[4,65,69,260],[3,66,69,198],[13,56,69,728],[24,45,69,1080],[15,54,69,810],[21,48,69,1008],[9,60,69,540],[2,68,70,136],[5,65,70,325],[15,55,70,825],[26,44,70,1144],[10,60,70,600],[6,64,70,384],[30,40,70,1200],[22,48,70,1056],[16,54,70,864],[7,63,70,441],[24,46,70,1104],[34,36,70,1224],[8,62,70,496],[18,52,70,936],[19,51,70,969],[14,56,70,784],[4,66,70,264],[12,58,70,696],[20,50,70,1000],[32,38,70,1216],[25,45,70,1125],[13,57,70,741],[28,42,70,1176],[33,38,71,1254],[11,60,71,660],[23,48,71,1104],[3,68,71,204],[26,45,71,1170],[22,49,71,1078],[8,63,71,504],[32,39,71,1248],[29,42,71,1218],[13,58,71,754],[16,55,71,880],[6,65,71,390],[17,54,71,918],[21,50,71,1050],[27,44,71,1188],[35,36,71,1260],[28,43,71,1204],[14,57,71,798],[30,41,71,1230],[2,69,71,138],[15,56,71,840],[19,52,71,988],[34,37,71,1258],[25,46,71,1150],[20,51,71,1020],[31,40,71,1240],[5,66,71,330],[9,62,71,558],[7,64,71,448],[4,68,72,272],[18,54,72,972],[2,70,72,140],[34,38,72,1292],[12,60,72,720],[26,46,72,1196],[3,69,72,207],[10,62,72,620],[21,51,72,1071],[6,66,72,396],[20,52,72,1040],[24,48,72,1152],[16,56,72,896],[32,40,72,1280],[7,65,72,455],[28,44,72,1232],[17,55,72,935],[22,50,72,1100],[9,63,72,567],[8,64,72,512],[30,42,72,1260],[14,58,72,812],[27,45,72,1215],[15,57,72,855],[22,51,73,1122],[32,41,73,1312],[23,50,73,1150],[36,37,73,1332],[16,57,73,912],[17,56,73,952],[27,46,73,1242],[18,55,73,990],[34,39,73,1326],[11,62,73,682],[35,38,73,1330],[5,68,73,340],[25,48,73,1200],[31,42,73,1302],[4,69,73,276],[28,45,73,1260],[9,64,73,576],[24,49,73,1176],[3,70,73,210],[8,65,73,520],[13,60,73,780],[7,66,73,462],[10,63,73,630],[33,40,73,1320],[15,58,73,870],[19,54,73,1026],[29,44,73,1276],[21,52,73,1092],[6,68,74,408],[34,40,74,1360],[17,57,74,969],[10,64,74,640],[24,50,74,1200],[4,70,74,280],[11,63,74,693],[32,42,74,1344],[20,54,74,1080],[12,62,74,744],[26,48,74,1248],[18,56,74,1008],[16,58,74,928],[5,69,74,345],[36,38,74,1368],[8,66,74,528],[30,44,74,1320],[28,46,74,1288],[9,65,74,585],[35,39,74,1365],[2,72,74,144],[23,51,74,1173],[22,52,74,1144],[14,60,74,840],[21,54,75,1134],[18,57,75,1026],[3,72,75,216],[29,46,75,1334],[13,62,75,806],[19,56,75,1064],[36,39,75,1404],[17,58,75,986],[31,44,75,1364],[11,64,75,704],[33,42,75,1386],[10,65,75,650],[27,48,75,1296],[6,69,75,414],[12,63,75,756],[34,41,75,1394],[30,45,75,1350],[20,55,75,1100],[23,52,75,1196],[15,60,75,900],[35,40,75,1400],[7,68,75,476],[37,38,75,1406],[5,70,75,350],[9,66,75,594],[24,51,75,1224],[28,48,76,1344],[14,62,76,868],[4,72,76,288],[13,63,76,819],[21,55,76,1155],[12,64,76,768],[22,54,76,1188],[30,46,76,1380],[25,51,76,1275],[36,40,76,1440],[7,69,76,483],[6,70,76,420],[32,44,76,1408],[34,42,76,1428],[20,56,76,1120],[24,52,76,1248],[11,65,76,715],[18,58,76,1044],[2,74,76,148],[10,66,76,660],[16,60,76,960],[27,49,76,1323],[8,68,76,544],[26,50,76,1300],[2,75,77,150],[21,56,77,1176],[32,45,77,1440],[5,72,77,360],[3,74,77,222],[8,69,77,552],[17,60,77,1020],[33,44,77,1452],[27,50,77,1350],[36,41,77,1476],[11,66,77,726],[20,57,77,1140],[38,39,77,1482],[31,46,77,1426],[13,64,77,832],[35,42,77,1470],[25,52,77,1300],[12,65,77,780],[26,51,77,1326],[29,48,77,1392],[15,62,77,930],[37,40,77,1480],[9,68,77,612],[23,54,77,1242],[7,70,77,490],[19,58,77,1102],[14,63,77,882],[32,46,78,1472],[33,45,78,1485],[15,63,78,945],[24,54,78,1296],[2,76,78,152],[22,56,78,1232],[36,42,78,1512],[30,48,78,1440],[28,50,78,1400],[18,60,78,1080],[3,75,78,225],[20,58,78,1160],[21,57,78,1197],[38,40,78,1520],[6,72,78,432],[34,44,78,1496],[9,69,78,621],[8,70,78,560],[14,64,78,896],[12,66,78,792],[16,62,78,992],[27,51,78,1377],[10,68,78,680],[4,74,78,296],[14,65,79,910],[28,51,79,1428],[19,60,79,1140],[23,56,79,1288],[25,54,79,1350],[4,75,79,300],[39,40,79,1560],[13,66,79,858],[31,48,79,1488],[3,76,79,228],[37,42,79,1554],[7,72,79,504],[24,55,79,1320],[30,49,79,1470],[16,63,79,1008],[2,77,79,154],[22,57,79,1254],[9,70,79,630],[33,46,79,1518],[10,69,79,690],[17,62,79,1054],[29,50,79,1450],[35,44,79,1540],[21,58,79,1218],[5,74,79,370],[27,52,79,1404],[11,68,79,748],[15,64,79,960],[34,45,79,1530],[12,68,80,816],[22,58,80,1276],[30,50,80,1500],[38,42,80,1596],[10,70,80,700],[18,62,80,1116],[32,48,80,1536],[2,78,80,156],[34,46,80,1564],[5,75,80,375],[8,72,80,576],[6,74,80,444],[3,77,80,231],[17,63,80,1071],[4,76,80,304],[15,65,80,975],[11,69,80,759],[28,52,80,1456],[26,54,80,1404],[20,60,80,1200],[23,57,80,1311],[36,44,80,1584],[35,45,80,1575],[24,56,80,1344],[14,66,80,924],[25,56,81,1400],[15,66,81,990],[16,65,81,1040],[4,77,81,308],[35,46,81,1610],[33,48,81,1584],[27,54,81,1458],[5,76,81,380],[9,72,81,648],[26,55,81,1430],[3,78,81,234],[39,42,81,1638],[21,60,81,1260],[11,70,81,770],[30,51,81,1530],[19,62,81,1178],[29,52,81,1508],[7,74,81,518],[31,50,81,1550],[32,49,81,1568],[23,58,81,1334],[6,75,81,450],[12,69,81,828],[36,45,81,1620],[17,64,81,1088],[13,68,81,884],[24,57,81,1368],[37,44,81,1628],[18,63,81,1134],[4,78,82,312],[18,64,82,1152],[38,44,82,1672],[20,62,82,1240],[2,80,82,160],[26,56,82,1456],[22,60,82,1320],[13,69,82,897],[24,58,82,1392],[17,65,82,1105],[8,74,82,592],[34,48,82,1632],[10,72,82,720],[12,70,82,840],[19,63,82,1197],[6,76,82,456],[30,52,82,1560],[33,49,82,1617],[27,55,82,1485],[36,46,82,1656],[5,77,82,385],[32,50,82,1600],[7,75,82,525],[25,57,82,1425],[14,68,82,952],[16,66,82,1056],[28,54,82,1512],[40,42,82,1680],[14,69,83,966],[39,44,83,1716],[21,62,83,1302],[5,78,83,390],[20,63,83,1260],[25,58,83,1450],[27,56,83,1512],[35,48,83,1680],[28,55,83,1540],[23,60,83,1380],[7,76,83,532],[6,77,83,462],[31,52,83,1612],[32,51,83,1632],[33,50,83,1650],[15,68,83,1020],[18,65,83,1170],[19,64,83,1216],[17,66,83,1122],[8,75,83,600],[3,80,83,240],[2,81,83,162],[38,45,83,1710],[29,54,83,1566],[37,46,83,1702],[11,72,83,792],[26,57,83,1482],[13,70,83,910],[9,74,83,666],[2,82,84,164],[9,75,84,675],[40,44,84,1760],[15,69,84,1035],[30,54,84,1620],[16,68,84,1088],[21,63,84,1323],[26,58,84,1508],[27,57,84,1539],[34,50,84,1700],[28,56,84,1568],[10,74,84,740],[14,70,84,980],[38,46,84,1748],[32,52,84,1664],[8,76,84,608],[6,78,84,468],[39,45,84,1755],[7,77,84,539],[20,64,84,1280],[22,62,84,1364],[3,81,84,243],[36,48,84,1728],[4,80,84,320],[12,72,84,864],[18,66,84,1188],[24,60,84,1440],[9,76,85,684],[15,70,85,1050],[39,46,85,1794],[35,50,85,1750],[30,55,85,1650],[3,82,85,246],[8,77,85,616],[27,58,85,1566],[19,66,85,1254],[31,54,85,1674],[21,64,85,1344],[36,49,85,1764],[23,62,85,1426],[4,81,85,324],[20,65,85,1300],[25,60,85,1500],[10,75,85,750],[16,69,85,1104],[37,48,85,1776],[40,45,85,1800],[5,80,85,400],[29,56,85,1624],[11,74,85,814],[7,78,85,546],[13,72,85,936],[28,57,85,1596],[22,63,85,1386],[33,52,85,1716],[18,68,86,1224],[14,72,86,1008],[9,77,86,693],[32,54,86,1728],[34,52,86,1768],[21,65,86,1365],[10,76,86,760],[22,64,86,1408],[42,44,86,1848],[17,69,86,1173],[5,81,86,405],[20,66,86,1320],[28,58,86,1624],[12,74,86,888],[11,75,86,825],[30,56,86,1680],[38,48,86,1824],[8,78,86,624],[23,63,86,1449],[4,82,86,328],[24,62,86,1488],[36,50,86,1800],[2,84,86,168],[16,70,86,1120],[6,80,86,480],[26,60,86,1560],[42,45,87,1890],[12,75,87,900],[35,52,87,1820],[7,80,87,560],[25,62,87,1550],[37,50,87,1850],[5,82,87,410],[21,66,87,1386],[27,60,87,1620],[39,48,87,1872],[19,68,87,1292],[15,72,87,1080],[30,57,87,1710],[13,74,87,962],[11,76,87,836],[31,56,87,1736],[18,69,87,1242],[17,70,87,1190],[6,81,87,486],[9,78,87,702],[3,84,87,252],[24,63,87,1512],[32,55,87,1760],[33,54,87,1782],[2,85,87,170],[22,65,87,1430],[10,77,87,770],[23,64,87,1472],[36,51,87,1836],[34,54,88,1836],[25,63,88,1575],[3,85,88,255],[30,58,88,1740],[36,52,88,1872],[7,81,88,567],[8,80,88,640],[19,69,88,1311],[6,82,88,492],[18,70,88,1260],[28,60,88,1680],[14,74,88,1036],[10,78,88,780],[4,84,88,336],[2,86,88,172],[20,68,88,1360],[24,64,88,1536],[40,48,88,1920],[16,72,88,1152],[32,56,88,1792],[12,76,88,912],[13,75,88,975],[42,46,88,1932],[22,66,88,1452],[26,62,88,1612],[19,70,89,1330],[9,80,89,720],[39,50,89,1950],[37,52,89,1924],[26,63,89,1638],[13,76,89,988],[7,82,89,574],[38,51,89,1938],[8,81,89,648],[31,58,89,1798],[2,87,89,174],[4,85,89,340],[3,86,89,258],[23,66,89,1518],[5,84,89,420],[15,74,89,1110],[17,72,89,1224],[35,54,89,1890],[11,78,89,858],[25,64,89,1600],[33,56,89,1848],[44,45,89,1980],[20,69,89,1380],[12,77,89,924],[24,65,89,1560],[40,49,89,1960],[27,62,89,1674],[29,60,89,1740],[32,57,89,1824],[21,68,89,1428],[14,75,89,1050],[42,48,90,2016],[3,87,90,261],[4,86,90,344],[6,84,90,504],[5,85,90,425],[22,68,90,1496],[15,75,90,1125],[21,69,90,1449],[28,62,90,1736],[20,70,90,1400],[12,78,90,936],[30,60,90,1800],[34,56,90,1904],[10,80,90,800],[2,88,90,176],[8,82,90,656],[24,66,90,1584],[14,76,90,1064],[16,74,90,1184],[18,72,90,1296],[32,58,90,1856],[36,54,90,1944],[26,64,90,1664],[16,75,91,1200],[13,78,91,1014],[22,69,91,1518],[7,84,91,588],[31,60,91,1860],[33,58,91,1914],[17,74,91,1258],[9,82,91,738],[21,70,91,1470],[35,56,91,1960],[3,88,91,264],[25,66,91,1650],[45,46,91,2070],[19,72,91,1368],[23,68,91,1564],[29,62,91,1798],[5,86,91,430],[10,81,91,810],[27,64,91,1728],[28,63,91,1764],[34,57,91,1938],[15,76,91,1140],[40,51,91,2040],[14,77,91,1078],[11,80,91,880],[4,87,91,348],[36,55,91,1980],[6,85,91,510],[11,81,92,891],[42,50,92,2100],[44,48,92,2112],[26,66,92,1716],[27,65,92,1755],[16,76,92,1216],[12,80,92,960],[10,82,92,820],[32,60,92,1920],[34,58,92,1972],[28,64,92,1792],[7,85,92,595],[14,78,92,1092],[15,77,92,1155],[2,90,92,180],[38,54,92,2052],[30,62,92,1860],[4,88,92,352],[40,52,92,2080],[17,75,92,1275],[20,72,92,1440],[18,74,92,1332],[24,68,92,1632],[5,87,92,435],[8,84,92,672],[6,86,92,516],[22,70,92,1540],[36,56,92,2016],[19,74,93,1406],[36,57,93,2052],[33,60,93,1980],[16,77,93,1232],[24,69,93,1656],[7,86,93,602],[27,66,93,1782],[35,58,93,2030],[45,48,93,2160],[8,85,93,680],[5,88,93,440],[42,51,93,2142],[29,64,93,1856],[6,87,93,522],[3,90,93,270],[28,65,93,1820],[25,68,93,1700],[21,72,93,1512],[23,70,93,1610],[11,82,93,902],[30,63,93,1890],[9,84,93,756],[2,91,93,182],[18,75,93,1350],[12,81,93,972],[17,76,93,1292],[15,78,93,1170],[13,80,93,1040],[42,52,94,2184],[12,82,94,984],[18,76,94,1368],[6,88,94,528],[24,70,94,1680],[8,86,94,688],[3,91,94,273],[20,74,94,1480],[19,75,94,1425],[22,72,94,1584],[32,62,94,1984],[40,54,94,2160],[44,50,94,2200],[10,84,94,840],[14,80,94,1120],[9,85,94,765],[4,90,94,360],[7,87,94,609],[39,55,94,2145],[34,60,94,2040],[25,69,94,1725],[13,81,94,1053],[45,49,94,2205],[28,66,94,1848],[30,64,94,1920],[26,68,94,1768],[2,92,94,184],[16,78,94,1248],[18,77,95,1386],[13,82,95,1066],[3,92,95,276],[14,81,95,1134],[11,84,95,924],[33,62,95,2046],[35,60,95,2100],[27,68,95,1836],[40,55,95,2200],[30,65,95,1950],[9,86,95,774],[4,91,95,364],[32,63,95,2016],[29,66,95,1914],[8,87,95,696],[23,72,95,1656],[10,85,95,850],[31,64,95,1984],[2,93,95,186],[21,74,95,1554],[44,51,95,2244],[7,88,95,616],[5,90,95,450],[25,70,95,1750],[15,80,95,1200],[26,69,95,1794],[20,75,95,1500],[39,56,95,2184],[17,78,95,1326],[22,74,96,1628],[4,92,96,368],[15,81,96,1215],[11,85,96,935],[20,76,96,1520],[28,68,96,1904],[12,84,96,1008],[16,80,96,1280],[34,62,96,2108],[14,82,96,1148],[42,54,96,2268],[26,70,96,1820],[30,66,96,1980],[24,72,96,1728],[40,56,96,2240],[18,78,96,1404],[21,75,96,1575],[10,86,96,860],[6,90,96,540],[2,94,96,188],[9,87,96,783],[3,93,96,279],[36,60,96,2160],[5,91,96,455],[8,88,96,704],[13,84,97,1092],[25,72,97,1800],[3,94,97,282],[12,85,97,1020],[32,65,97,2080],[23,74,97,1702],[2,95,97,190],[15,82,97,1230],[28,69,97,1932],[16,81,97,1296],[9,88,97,792],[19,78,97,1482],[20,77,97,1540],[21,76,97,1596],[45,52,97,2340],[6,91,97,546],[29,68,97,1972],[4,93,97,372],[10,87,97,870],[5,92,97,460],[33,64,97,2112],[7,90,97,630],[40,57,97,2280],[22,75,97,1650],[31,66,97,2046],[34,63,97,2142],[17,80,97,1360],[48,49,97,2352],[11,86,97,946],[27,70,97,1890],[20,78,98,1560],[18,80,98,1440],[42,56,98,2352],[21,77,98,1617],[33,65,98,2145],[23,75,98,1725],[35,63,98,2205],[30,68,98,2040],[4,94,98,376],[28,70,98,1960],[5,93,98,465],[38,60,98,2280],[48,50,98,2400],[12,86,98,1032],[17,81,98,1377],[24,74,98,1776],[8,90,98,720],[3,95,98,285],[10,88,98,880],[11,87,98,957],[7,91,98,637],[14,84,98,1176],[22,76,98,1672],[2,96,98,192],[32,66,98,2112],[16,82,98,1312],[34,64,98,2176],[6,92,98,552],[13,85,98,1105],[26,72,98,1872],[9,90,99,810],[5,94,99,470],[4,95,99,380],[11,88,99,968],[13,86,99,1118],[14,85,99,1190],[8,91,99,728],[17,82,99,1394],[7,92,99,644],[6,93,99,558],[27,72,99,1944],[29,70,99,2030],[31,68,99,2108],[36,63,99,2268],[35,64,99,2240],[21,78,99,1638],[25,74,99,1850],[23,76,99,1748],[39,60,99,2340],[24,75,99,1800],[18,81,99,1458],[30,69,99,2070],[19,80,99,1520],[3,96,99,288],[12,87,99,1044],[15,84,99,1260],[4,96,100,384],[12,88,100,1056],[34,66,100,2244],[9,91,100,819],[24,76,100,1824],[15,85,100,1275],[7,93,100,651],[20,80,100,1600],[18,82,100,1476],[10,90,100,900],[5,95,100,475],[14,86,100,1204],[28,72,100,2016],[32,68,100,2176],[13,87,100,1131],[6,94,100,564],[22,78,100,1716],[40,60,100,2400],[8,92,100,736],[26,74,100,1924],[16,84,100,1344],[19,81,100,1539],[2,98,100,196],[30,70,100,2100]]

?- time(s2(Q,100)).
% 250,076 inferences, 0.089 CPU in 0.101 seconds (88% CPU, 2809148 Lips)
Q = [[2,9,11,18],[3,8,11,24],[4,7,11,28],[5,6,11,30],[2,15,17,30],[3,14,17,42],[2,21,23,42],[2,25,27,50],[4,13,17,52],[2,27,29,54],[3,20,23,60],[5,12,17,60],[2,33,35,66],[6,11,17,66],[2,35,37,70],[7,10,17,70],[8,9,17,72],[3,24,27,72],[4,19,23,76],[3,26,29,78],[2,39,41,78],[2,45,47,90],[5,18,23,90],[4,23,27,92],[3,32,35,96],[4,25,29,100],[6,17,23,102],[2,51,53,102],[3,34,37,102],[5,22,27,110],[7,16,23,112],[3,38,41,114],[8,15,23,120],[5,24,29,120],[4,31,35,124],[6,21,27,126],[9,14,23,126],[10,13,23,130],[4,33,37,132],[3,44,47,132],[11,12,23,132],[6,23,29,138],[7,20,27,140],[4,37,41,148],[5,30,35,150],[3,50,53,150],[8,19,27,152],[7,22,29,154],[5,32,37,160],[9,18,27,162],[8,21,29,168],[10,17,27,170],[4,43,47,172],[6,29,35,174],[11,16,27,176],[5,36,41,180],[9,20,29,180],[12,15,27,180],[13,14,27,182],[6,31,37,186],[10,19,29,190],[4,49,53,196],[7,28,35,196],[11,18,29,198],[12,17,29,204],[13,16,29,208],[7,30,37,210],[14,15,29,210],[6,35,41,210],[5,42,47,210],[8,27,35,216],[8,29,37,232],[9,26,35,234],[7,34,41,238],[5,48,53,240],[6,41,47,246],[10,25,35,250],[9,28,37,252],[11,24,35,264],[8,33,41,264],[10,27,37,270],[12,23,35,276],[7,40,47,280],[6,47,53,282],[11,26,37,286],[13,22,35,286],[9,32,41,288],[14,21,35,294],[12,25,37,300],[15,20,35,300],[16,19,35,304],[17,18,35,306],[10,31,41,310],[8,39,47,312],[13,24,37,312],[14,23,37,322],[7,46,53,322],[11,30,41,330],[15,22,37,330],[16,21,37,336],[17,20,37,340],[18,19,37,342],[9,38,47,342],[12,29,41,348],[8,45,53,360],[13,28,41,364],[10,37,47,370],[14,27,41,378],[15,26,41,390],[9,44,53,396],[11,36,47,396],[16,25,41,400],[17,24,41,408],[18,23,41,414],[19,22,41,418],[12,35,47,420],[20,21,41,420],[10,43,53,430],[13,34,47,442],[14,33,47,462],[11,42,53,462],[15,32,47,480],[12,41,53,492],[16,31,47,496],[17,30,47,510],[13,40,53,520],[18,29,47,522],[19,28,47,532],[20,27,47,540],[14,39,53,546],[21,26,47,546],[22,25,47,550],[23,24,47,552],[15,38,53,570],[16,37,53,592],[17,36,53,612],[18,35,53,630],[19,34,53,646],[20,33,53,660],[21,32,53,672],[22,31,53,682],[23,30,53,690],[24,29,53,696],[25,28,53,700],[26,27,53,702]]

?- time(s3(Q,100)).
% 251,484 inferences, 0.090 CPU in 0.100 seconds (90% CPU, 2794484 Lips)
Q = [[2,9,11,18],[4,7,11,28],[3,8,11,24],[4,13,17,52],[4,19,23,76],[10,13,23,130],[7,16,23,112],[7,20,27,140],[8,19,27,152],[5,22,27,110],[11,16,27,176],[9,18,27,162],[2,25,27,50],[13,14,27,182],[4,23,27,92],[10,17,27,170],[13,16,29,208],[8,21,29,168],[11,18,29,198],[4,25,29,100],[2,27,29,54],[10,19,29,190],[7,22,29,154],[6,23,29,138],[12,17,29,204],[17,18,35,306],[3,32,35,96],[12,23,35,276],[14,21,35,294],[8,27,35,216],[6,29,35,174],[4,31,35,124],[9,26,35,234],[10,25,35,250],[16,19,35,304],[9,28,37,252],[5,32,37,160],[6,31,37,186],[8,29,37,232],[16,21,37,336],[10,27,37,270],[17,20,37,340],[14,27,41,378],[7,34,41,238],[12,29,41,348],[3,38,41,114],[18,23,41,414],[16,25,41,400],[13,28,41,364],[4,37,41,148],[10,31,41,310],[15,26,41,390],[9,32,41,288],[19,22,41,418],[17,24,41,408],[15,32,47,480],[22,25,47,550],[4,43,47,172],[16,31,47,496],[6,41,47,246],[19,28,47,532],[23,24,47,552],[18,29,47,522],[17,30,47,510],[7,40,47,280],[20,27,47,540],[10,37,47,370],[13,34,47,442],[21,32,53,672],[13,40,53,520],[25,28,53,700],[6,47,53,282],[17,36,53,612],[23,30,53,690],[15,38,53,570],[19,34,53,646],[10,43,53,430],[12,41,53,492],[22,31,53,682],[5,48,53,240],[8,45,53,360],[26,27,53,702],[18,35,53,630],[24,29,53,696],[16,37,53,592],[20,33,53,660]]

?- time(s4(Q,100)).
% 251,563 inferences, 0.091 CPU in 0.103 seconds (89% CPU, 2750314 Lips)
Q = [[4,13,17,52]].

?- time(s4(Q,500)).
% 20,042,723 inferences, 8.054 CPU in 8.489 seconds (95% CPU, 2488648 Lips)
Q = [[4,13,17,52]].
*/


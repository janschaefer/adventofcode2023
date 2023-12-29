import { readFileSync, writeFileSync } from 'fs';
import * as math from 'mathjs';

interface Hailstone {
  positions: number[]; // x, y, z
  velocity: number[]; // vx, vy, vz in nanoseconds
}

function parse(fileName: string): Hailstone[] {
  return readFileSync(fileName, 'utf8').split('\n')
     .map(line => {
       let splitted = line.split('@');
       return {
         positions: splitted[0].split(',').map( x => Number(x.trim())),
         velocity: splitted[1].split(',').map( x => Number(x.trim())),
       }
     })
}

function intersect(h1: Hailstone, h2: Hailstone): number[] {
  let x1 = h1.positions[0];
  let y1 = h1.positions[1];
  let vx1 = h1.velocity[0];
  let vy1 = h1.velocity[1];

  let x2 = h2.positions[0];
  let y2 = h2.positions[1];
  let vx2 = h2.velocity[0];
  let vy2 = h2.velocity[1];

  if (vx1 === 0 || vx2 === 0) {
    return undefined;
  }

  let a1 = vy1 / vx1;
  let b1 = y1 - a1 * x1;

  let a2 = vy2 / vx2;
  let b2 = y2 - a2 * x2

  if (a1 === a2) {
    if (b1 === b2) { 
      return undefined; // identical
    }
    return undefined; // parallel
  }

  if ((a1 - a2) === 0) {
    return undefined;
  }

  let cx = (b2 - b1) / (a1 - a2)
  let cy = cx * a1 + b1

  return [cx, cy];
}

function intersect_in_future(h1: Hailstone, h2: Hailstone): number[] {
  let p = intersect(h1, h2);
  if (!p) {
    return undefined;
  }
  
  let in_future = (p[0] > h1.positions[0]) === (h1.velocity[0] > 0) && 
    (p[0] > h2.positions[0]) === (h2.velocity[0] > 0);

  if (!in_future) {
    return undefined
  }

  return p;
}

function intersect_in_area( h1: Hailstone, h2: Hailstone, min: number, max: number ): boolean {
  let p = intersect_in_future(h1, h2);
  if (p === undefined) {
    return false;
  }
  
  let in_area = p[0] >= min && p[0] <= max && p[1] >= min && p[1] <= max;

  return in_area;
}

function solve(hailstones: Hailstone[]) {
  let min = 200000000000000;
  let max = 400000000000000;

  let count = 0;
  
  for (let i = 0; i < hailstones.length; i++) {
    for (let j = i+1; j < hailstones.length; j++) {
      let h1 = hailstones[i];
      let h2 = hailstones[j];

      if (intersect_in_area(h1, h2, min, max)) {
        count++;
      }
    }
  }
 
  console.log(count);
}

function crossProduct(v1: number[], v2: number[]): number[] {
    return [
        v1[1] * v2[2] - v1[2] * v2[1], 
        v1[2] * v2[0] - v1[0] * v2[2], 
        v1[0] * v2[1] - v1[1] * v2[0], 
    ];
}

function sub( v1: number[], v2: number[]): number[] {
    return [v1[0] - v2[0], v1[1] - v2[1], v1[2] - v2[2]];
}

function crossMatrix(v: number[]): number[][] {
    return [
        [0, -v[2], v[1]],
        [v[2], 0, -v[0]],
        [-v[1], v[0], 0]
    ];
}

function solve2(hailstones: Hailstone[]) {
  // it does not work for all hailstones because of precision problems, here I pick three random ones that work
  let hs = [hailstones[0], hailstones[10], hailstones[20]];

  let p1 = hs[0].positions;
  let p2 = hs[1].positions;
  let p3 = hs[2].positions;

  let v1 = hs[0].velocity;
  let v2 = hs[1].velocity;
  let v3 = hs[2].velocity;

  let p1xv1 = crossProduct(p1, v1);
  let p2xv2 = crossProduct(p2, v2);
  let p3xv3 = crossProduct(p3, v3);

  let b1 = sub(p1xv1, p2xv2);
  let b2 = sub(p1xv1, p3xv3);

  let rhs = b1.concat(b2);

  let m1 = crossMatrix(sub(v1, v2));
  let m2 = crossMatrix(sub(v1, v3));
  let m3 = crossMatrix(sub(p1, p2));
  let m4 = crossMatrix(sub(p1, p3));

  let coefficients = [
    [ m1[0][0], m1[0][1], m1[0][2], m3[0][0], m3[0][1], m3[0][2] ],
    [ m1[1][0], m1[1][1], m1[1][2], m3[1][0], m3[1][1], m3[1][2] ],
    [ m1[2][0], m1[2][1], m1[2][2], m3[2][0], m3[2][1], m3[2][2] ],
    [ m2[0][0], m2[0][1], m2[0][2], m4[0][0], m4[0][1], m4[0][2] ],
    [ m2[1][0], m2[1][1], m2[1][2], m4[1][0], m4[1][1], m4[1][2] ],
    [ m2[2][0], m2[2][1], m2[2][2], m4[2][0], m4[2][1], m4[2][2] ]
  ];

  const s = math.lusolve(coefficients, rhs);

  
  let result =  - (s[0][0] + s[1][0] + s[2][0]);

  console.log(Math.round(result));
}


let hailstones = parse("input");

solve(hailstones);
solve2(hailstones);
